//
//  WeatherMapper.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation

struct WeatherMapper {
    
    /// Converts the API's 'WeatherResponse' into our app's 'WeatherItemModel'.
    static func mapWeatherResponse(response: WeatherResponse) -> WeatherItemModel {
        
        // Get the first weather condition, or use defaults
        let weather = response.weather.first
        
        // 1. Map Coordinates
        let coordinates = Coordinates(longitude: response.coord.lon,
                                      latitude: response.coord.lat)
        
        // 2. Map WeatherStatus (your old flat object)
        let weatherStatus = WeatherStatus(
            weatherConditionId: weather?.id ?? 0,
            weatherConditionIcon: weather?.icon ?? "01d",
            weatherConditionDescription: weather?.description ?? "Unknown",
            weatherTemp: response.main.temp,
            weatherTempMin: response.main.tempMin,
            weatherTempMax: response.main.tempMax,
            weatherPressure: response.main.pressure,
            weatherHumidity: response.main.humidity,
            weatherWind: response.wind // This maps directly!
        )
        
        let utcTime = Date(timeIntervalSince1970: response.dt) // 2023-09-10 00:00:00 UTC
        let locationWeatherDay = AppUtils.convertUTCToDayOfMonth(utcTime: utcTime)
        // 3. Build the final WeatherItemModel
        let itemModel = WeatherItemModel(
            locationName: response.name,
            locationId: response.id,
            locationDate: response.dt,
            locationCoordinates: coordinates,
            locationWeather: weatherStatus,
            locationWeatherDay: locationWeatherDay
        )
        
        return itemModel
    }
    
    /// Converts the API's 'ForecastResponse' into an array of 'WeatherItemModel'.
    static func mapForecastResponse(response: ForecastResponse) -> [WeatherItemModel] {
        
        // 1. Create the shared coordinates from the "city" object
        let coordinates = Coordinates(longitude: response.city.coord.lon,
                                      latitude: response.city.coord.lat)
        
        var weatherList = [WeatherItemModel]()
        
        for (_, forecastItem) in response.list.enumerated(){
            
            // Get the first weather condition, or use defaults
            let weather = forecastItem.weather.first
            
            // 3. Create the WeatherStatus for this 3-hour slice
            let weatherStatus = WeatherStatus(
                weatherConditionId: weather?.id ?? 0,
                weatherConditionIcon: weather?.icon ?? "01d",
                weatherConditionDescription: weather?.description ?? "Unknown",
                weatherTemp: forecastItem.main.temp,
                weatherTempMin: forecastItem.main.tempMin,
                weatherTempMax: forecastItem.main.tempMax,
                weatherPressure: forecastItem.main.pressure,
                weatherHumidity: forecastItem.main.humidity,
                weatherWind: forecastItem.wind
            )
            let utcTime = Date(timeIntervalSince1970: forecastItem.dt) // 2023-09-10 00:00:00 UTC
            let locationWeatherDay = AppUtils.convertUTCToDayOfMonth(utcTime: utcTime)
            // 4. Build the final WeatherItemModel for this slice
            let weatherItemModel = WeatherItemModel(
                locationName: response.city.name, // Use city name for all
                locationId: response.city.id,     // Use city ID for all
                locationDate: forecastItem.dt,    // Use the item's timestamp
                locationCoordinates: coordinates, // Use shared coordinates
                locationWeather: weatherStatus,
                locationWeatherDay: locationWeatherDay
            )
            let isDataOntheList = weatherList.contains(where: { $0.locationWeatherDay == locationWeatherDay })
            
            //group the weather data by date
            let groupeddata = Dictionary(grouping: weatherList,by: { $0.locationWeatherDay })
            
            let today = AppUtils.getDayOfMonth()
            
            if !isDataOntheList && locationWeatherDay != today {
                weatherList.append(weatherItemModel)
            }
        }
        return weatherList
    }

}
