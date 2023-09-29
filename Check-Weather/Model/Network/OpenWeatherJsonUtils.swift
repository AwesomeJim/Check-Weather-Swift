//
//  OpenWeatherJsonUtils.swift
//  Check-Weather
//
//  Created by Awesome Jim on 10/09/2023.
//

import Foundation


/**
 * Utility functions to handle OpenWeatherMap JSON data.
 */
class OpenWeatherJsonUtils {
    
    /**
     * Fields in API response
     *
     *
     * coord
     * coord.lon City geo location, longitude
     * coord.lat City geo location, latitude
     * weather (more info Weather condition codes)
     * weather.id Weather condition id
     * weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
     * weather.description Weather condition within the group. You can get the output in your language. Learn more
     * weather.icon Weather icon id
     * base Internal parameter
     * main
     *     main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     *     main.feels_like Temperature. This temperature parameter accounts for the human perception of weather. Unit Default: Kelvin, Metric: Celsius, Imperial:                          Fahrenheit.
     *     main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
     *     main.humidity Humidity, %
     *     main.temp_min Minimum temperature at the moment. This is minimal currently observed temperature (within large megalopolises and urban areas).                         Unit  Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     *     main.temp_max Maximum temperature at the moment. This is maximal currently observed temperature (within large megalopolises and urban areas).                        Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
     *     main.sea_level Atmospheric pressure on the sea level, hPa
     *      main.grnd_level Atmospheric pressure on the ground level, hPa
     * wind
     *      wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
     *       wind.deg Wind direction, degrees (meteorological)
     *      wind.gust Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour
     * clouds
     *      clouds.all Cloudiness, %
     * rain
     *    rain.1h Rain volume for the last 1 hour, mm
     *    rain.3h Rain volume for the last 3 hours, mm
     * snow
     *    snow.1h Snow volume for the last 1 hour, mm
     * snow.3h Snow volume for the last 3 hours, mm
     * dt Time of data calculation, unix, UTC
     * sys
     * sys.type Internal parameter
     * sys.id Internal parameter
     * sys.message Internal parameter
     * sys.country Country code (GB, JP etc.)
     * sys.sunrise Sunrise time, unix, UTC
     * sys.sunset Sunset time, unix, UTC
     * timezone Shift in seconds from UTC
     * id City ID
     * name City name
     * cod Internal parameter
     */
    
    
    /**
     * This method parses JSON from a web response and returns an array of Strings
     * describing the weather over various days from the forecast.
     *
     *
     * Later on, we'll be parsing the JSON into structured data within the
     * getFullWeatherDataFromJson function, leveraging the data we have stored in the JSON. For
     * now, we just convert the JSON into human-readable strings.
     *
     * @param forecastJson JSON response from server
     * @return Array of Strings describing weather data
     * @throws JSONException If JSON data cannot be properly parsed
     */
    
    class func getWeatherContentValuesFromJson(weatherData: String) -> WeatherItemModel? {
        //
        do{
            //
            guard let rdata = weatherData.data(using: .utf8), let rawDict = try JSONSerialization.jsonObject(with: rdata, options: []) as? [String: Any] else {
                //
                AppUtils.Log(from:self,with:"Error: Couldn't decode rdata")
                return nil
            }
            
            //
            guard let code = rawDict[ConstantsEnum.OWM_MESSAGE_CODE] as? Int, code == 200 else {
                
                AppUtils.Log(from:self,with:"Error: load Data data or invalid location")
                return nil
            }
            AppUtils.Log(from:self,with:"Response Code :: \(code)")
            //
            guard var locationName = rawDict[ConstantsEnum.OWM_CITY_NAME] as? String,
                  let timeInMilliSeconds = rawDict["dt"] as? Double,
                  let locationId = rawDict[ConstantsEnum.OWM_CITY_ID] as? Int,
                  let coord = rawDict[ConstantsEnum.OWM_COORD] as? [String:Any],
                  let weatherForecast = rawDict[ConstantsEnum.OWM_WEATHER] as? [[String:Any]],
                  let mainForecast = rawDict[ConstantsEnum.OWM_MAIN] as? [String:Any],
                  let windForecast = rawDict[ConstantsEnum.OWM_WIND] as? [String:Any],
                  let sys = rawDict["sys"] as? [String:Any],
                  let country = sys["country"] as? String
                    
            else {
                AppUtils.Log(from:self,with:"Error: Couldn't decode response data")
                return nil
            }
            
            locationName = "\(locationName) \(country)"
            
            let cityLatitude = coord[ConstantsEnum.OWM_LATITUDE] as? Double ?? 0.0
            let cityLongitude = coord[ConstantsEnum.OWM_LONGITUDE] as? Double ?? 0.0
            let coordinates = Coordinates(
                longitude: cityLongitude,
                latitude: cityLatitude
            )
            
            //
            guard let weatherForecastItem = weatherForecast.first,
                 // let weatherCondition = weatherForecastItem[ConstantsEnum.OWM_MAIN] as? String,
                  let weatherConditionDescription = weatherForecastItem["description"] as? String,
                  let weatherConditionicon = weatherForecastItem["icon"] as? String,
                  let weatherConditionId = weatherForecastItem[ConstantsEnum.OWM_WEATHER_ID] as? Int
            else {
                
                AppUtils.Log(from:self,with:"Error: Couldn't decode weather Forecast data ")
                return nil
            }
            
            
            guard let weatherTemp = mainForecast[ConstantsEnum.OWM_TEMPERATURE] as? Double,
                  let weatherTempMin = mainForecast[ConstantsEnum.OWM_MIN] as? Double,
                  let weatherTempMax = mainForecast[ConstantsEnum.OWM_MAX] as? Double,
                  let weatherPressure = mainForecast[ConstantsEnum.OWM_PRESSURE] as? Double,
                  let weatherHumidity = mainForecast[ConstantsEnum.OWM_HUMIDITY] as? Int
            else {
                AppUtils.Log(from:self,with:"Error: Couldn't decode mainForecast data")
                return nil
            }
            
            guard
                let windSpeed = windForecast[ConstantsEnum.OWM_WINDSPEED] as? Double,
                let windDirection = windForecast[ConstantsEnum.OWM_WIND_DIRECTION] as? Double
            else {
                
                AppUtils.Log(from:self,with:"Error: Couldn't decode from windForecast data")
                return nil
            }
            
            let wind = Wind(speed: windSpeed, deg: windDirection)
            
            let utcTime = Date(timeIntervalSince1970: timeInMilliSeconds) // 2023-09-10 00:00:00 UTC
            let locationWeatherDay = AppUtils.convertUTCToDayOfMonth(utcTime: utcTime)
            
            let weatherStatus = WeatherStatus(
                weatherConditionId: weatherConditionId,
                weatherConditionIcon:weatherConditionicon,
                weatherConditionDescription: weatherConditionDescription,
                weatherTemp: weatherTemp,
                weatherTempMin: weatherTempMin,
                weatherTempMax: weatherTempMax,
                weatherPressure: weatherPressure,
                weatherHumidity: weatherHumidity,
                weatherWind: wind
            )
            
            let weatherItemModel = WeatherItemModel(
                locationName: locationName,
                locationId: locationId,
                locationDate: timeInMilliSeconds,
                locationCoordinates: coordinates,
                locationWeather: weatherStatus,
                locationWeatherDay: locationWeatherDay
            )
            return weatherItemModel
            
        }catch{
            AppUtils.Log(from:self,with:"Decode data Failed :: \(error)")
            return nil
        }
    }
    
    
    /*
     {
     "cod": "200",
     "message": 0,
     "cnt": 40,
     "list": [
     {
     "dt": 1634493600,
     "main": {
     "temp": 18.81,
     "feels_like": 18.76,
     "temp_min": 18.81,
     "temp_max": 21.45,
     "pressure": 1019,
     "sea_level": 1019,
     "grnd_level": 837,
     "humidity": 77,
     "temp_kf": -2.64
     },
     "weather": [
     {
     "id": 803,
     "main": "Clouds",
     "description": "broken clouds",
     "icon": "04n"
     }
     ],
     "clouds": {
     "all": 75
     },
     "wind": {
     "speed": 5.54,
     "deg": 79,
     "gust": 7.92
     },
     "visibility": 10000,
     "pop": 0.19,
     "sys": {
     "pod": "n"
     },
     "dt_txt": "2021-10-17 18:00:00"
     },
     "city": {
     "id": 184745,
     "name": "Nairobi",
     "coord": {
     "lat": -1.2833,
     "lon": 36.8167
     },
     "country": "KE",
     "population": 2750547,
     "timezone": 10800,
     "sunrise": 1634440423,
     "sunset": 1634484127
     }
     */
    
    /**
     * This method parses JSON from a web response and returns an array of Strings
     * describing the weather over various days from the forecast.
     *
     *
     * Later on, we'll be parsing the JSON into structured data within the
     * getFullWeatherDataFromJson function, leveraging the data we have stored in the JSON. For
     * now, we just convert the JSON into human-readable strings.
     *
     * @param forecastJson JSON response from server
     * @return Array of Strings describing weather data
     * @throws JSONException If JSON data cannot be properly parsed
     */
    
    class func getWeatherForecastContentValuesFromJson(weatherData: String) -> [WeatherItemModel]?{
        //
        do{
            //
            guard let rdata = weatherData.data(using: .utf8), let rawDict = try JSONSerialization.jsonObject(with: rdata, options: []) as? [String: Any] else {
                //
                AppUtils.Log(from:self,with:"Error: Couldn't decode rdata")
                return nil
            }
            
            //
            guard let code = rawDict[ConstantsEnum.OWM_MESSAGE_CODE] as? String, code == "200" else {
                AppUtils.Log(from:self,with:"Error: load Data data or invalid location")
                return nil
            }
            AppUtils.Log(from:self,with:"Response Code :: \(code)")
            
            /*City details*/
            
            guard let city = rawDict[ConstantsEnum.OWM_CITY] as? [String:Any],
                  var locationName = city[ConstantsEnum.OWM_CITY_NAME] as? String,
                  let locationId = city[ConstantsEnum.OWM_CITY_ID] as? Int,
                  let country = city["country"] as? String,
                  let jsonWeatherArray = rawDict[ConstantsEnum.OWM_LIST] as? [[String:Any]]
            else {
                AppUtils.Log(from:self,with:"Error: Couldn't decode city response data")
                return nil
            }
            
            locationName = "\(locationName) \(country)"
            /*City Coord*/
            let cityLatitude = city[ConstantsEnum.OWM_LATITUDE] as? Double ?? 0.0
            let cityLongitude = city[ConstantsEnum.OWM_LONGITUDE] as? Double ?? 0.0
            let coordinates = Coordinates(
                longitude: cityLongitude,
                latitude: cityLatitude
            )
            
            var weatherList = [WeatherItemModel]()
            
            for (_, dayForecast) in jsonWeatherArray.enumerated(){
                guard
                    let timeInMilliSeconds = dayForecast["dt"] as? Double,
                    let weatherForecast = dayForecast[ConstantsEnum.OWM_WEATHER] as? [[String:Any]],
                    let weatherForecastItem = weatherForecast.first,
                   // let weatherCondition = weatherForecastItem[ConstantsEnum.OWM_MAIN] as? String,
                    let weatherConditionDescription = weatherForecastItem["description"] as? String,
                    let weatherConditionicon = weatherForecastItem["icon"] as? String,
                    let weatherConditionId = weatherForecastItem[ConstantsEnum.OWM_WEATHER_ID] as? Int,
                    let mainForecast = dayForecast[ConstantsEnum.OWM_MAIN] as? [String:Any],
                    let windForecast = dayForecast[ConstantsEnum.OWM_WIND] as? [String:Any]
                else {
                    AppUtils.Log(from:self,with:"Error: Couldn't decode mainForecast data")
                    return nil
                }
                
                
                guard let weatherTemp = mainForecast[ConstantsEnum.OWM_TEMPERATURE] as? Double,
                      let weatherTempMin = mainForecast[ConstantsEnum.OWM_MIN] as? Double,
                      let weatherTempMax = mainForecast[ConstantsEnum.OWM_MAX] as? Double,
                      let weatherPressure = mainForecast[ConstantsEnum.OWM_PRESSURE] as? Double,
                      let weatherHumidity = mainForecast[ConstantsEnum.OWM_HUMIDITY] as? Int
                else {
                    AppUtils.Log(from:self,with:"Error: Couldn't decode mainForecast data")
                    return nil
                }
                
                guard
                    let windSpeed = windForecast[ConstantsEnum.OWM_WINDSPEED] as? Double,
                    let windDirection = windForecast[ConstantsEnum.OWM_WIND_DIRECTION] as? Double
                else {
                    
                    AppUtils.Log(from:self,with:"Error: Couldn't decode from windForecast data")
                    return nil
                }
                
                let wind = Wind(speed: windSpeed, deg: windDirection)
                
                let utcTime = Date(timeIntervalSince1970: timeInMilliSeconds) // 2023-09-10 00:00:00 UTC
                let locationWeatherDay = AppUtils.convertUTCToDayOfMonth(utcTime: utcTime)
                
                let weatherStatus = WeatherStatus(
                    weatherConditionId: weatherConditionId,
                    weatherConditionIcon:weatherConditionicon,
                    weatherConditionDescription: weatherConditionDescription,
                    weatherTemp: weatherTemp,
                    weatherTempMin: weatherTempMin,
                    weatherTempMax: weatherTempMax,
                    weatherPressure: weatherPressure,
                    weatherHumidity: weatherHumidity,
                    weatherWind: wind
                )
                
                let weatherItemModel = WeatherItemModel(
                    locationName: locationName,
                    locationId: locationId,
                    locationDate: timeInMilliSeconds,
                    locationCoordinates: coordinates,
                    locationWeather: weatherStatus,
                    locationWeatherDay: locationWeatherDay
                )
                let isDataOntheList = weatherList.contains(where: { $0.locationWeatherDay == locationWeatherDay })
                
                //group the weather data by data
                let groupeddata = Dictionary(grouping: weatherList,by: { $0.locationWeatherDay })
                
                let today = AppUtils.getDayOfMonth()
                
                if !isDataOntheList && locationWeatherDay != today {
                    weatherList.append(weatherItemModel)
                }
            }
            return weatherList
            
        }catch{
            AppUtils.Log(from:self,with:"Decode data Failed :: \(error)")
            return nil
        }
    }
}
