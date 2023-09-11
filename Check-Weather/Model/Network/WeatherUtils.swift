//
//  WeatherUtils.swift
//  Check-Weather
//
//  Created by Awesome Jim on 10/09/2023.
//

import Foundation

/**
 * Contains useful utilities for a weather app, such as conversion between Celsius and Fahrenheit,
 * from kph to mph, and from degrees to NSEW.  It also contains the mapping of weather condition
 * codes in OpenWeatherMap to strings.  These strings are contained
 */

class WeatherUtils {
    
    /**
     * This method will convert a temperature from Celsius to Fahrenheit.
     *
     * @param temperatureInCelsius Temperature in degrees Celsius(°C)
     *
     * @return Temperature in degrees Fahrenheit (°F)
     */
    class func celsiusToFahrenheit(temperatureInCelsius: Double) -> Double {
        return temperatureInCelsius * 1.8 + 32
    }
    
    
    /**
     * Temperature data is stored in Celsius by our app. Depending on the user's preference,
     * the app may need to display the temperature in Fahrenheit. This method will perform that
     * temperature conversion if necessary. It will also format the temperature so that no
     * decimal points show. Temperatures will be formatted to the following form: "21°"
     *
     * @param context     Android Context to access preferences and resources
     * @param temperature Temperature in degrees Celsius (°C)
     *
     * @return Formatted temperature String in the following form:
     * "21°"
     */
    class func formatTemperature(temperature: Double) -> String {
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        
        return measurementFormatter.string(from: measurement)
    }
    
    
    /**
     * This method will format the temperatures to be displayed in the
     * following form: "HIGH° / LOW°"
     *
     * @param context Android Context to access preferences and resources
     * @param high    High temperature for a day in user's preferred units
     * @param low     Low temperature for a day in user's preferred units
     *
     * @return String in the form: "HIGH° / LOW°"
     */
    class func formatHighLows(high: Double,low: Double)  ->  String {
        let formattedHigh = formatTemperature(temperature: high)
        let formattedLow = formatTemperature(temperature: low)
        return "\(formattedHigh) / \(formattedLow)"
    }
    
    
    /**
     * This method uses the wind direction in degrees to determine compass direction as a
     * String. (eg NW) The method will return the wind String in the following form: "2 km/h SW"
     *
     * @param context   Android Context to access preferences and resources
     * @param windSpeed Wind speed in kilometers / hour
     * @param degrees   Degrees as measured on a compass, NOT temperature degrees!
     * See https://www.mathsisfun.com/geometry/degrees.html
     *
     * @return Wind String in the following form: "2 km/h SW"
     */
    class func getFormattedWind(windSpeed: Double, degrees: Double) -> String {
        let windFormat = "%1.0f km/h %@"
        
        var direction = "Unknown"
        switch degrees {
            case ...22.5 :
                direction = "N"
            case 337.5...:
                direction = "N"
            case 22.5...67.5:
                direction = "NE"
            case 67.5...112.5:
                direction = "E"
            case 112.5...157.5:
                direction = "SE"
            case 157.5...202.5:
                direction = "S"
            case 202.5...247.5:
                direction = "SW"
            case 247.5...292.5:
                direction = "W"
            case 292.5...337.5:
                direction = "NW"
            default:
                break
        }
        return String(format:windFormat, windSpeed, direction)
    }
    
    
    class func getFormattedHumidity(humidity: Int) -> String {
        let humidityFormat = "%1.0f %%"
        return String(format:humidityFormat, Double(humidity))
    }
    
    
    class func getFormattedPressure(pressure: Double) -> String {
        let pressureFormat = "%1.0f hPa"
        return String(format:pressureFormat, pressure)
    }
    
    /**
     * Helper method to provide the string according to the weather
     * condition id returned by the OpenWeatherMap call.
     *
     * @param context   Android context
     * @param weatherId from OpenWeatherMap API response
     * See http://openweathermap.org/weather-conditions for a list of all IDs
     *
     * @return String for the weather condition, null if no relation is found.
     */
    class func getStringForWeatherCondition(weatherId: Int) -> String {
        var condition = ""
        switch weatherId {
            case 200...232 :
                condition = "condition_2xx"
            case  300...321 :
                condition = "condition_3xx"
            case  500 :
                condition = "condition_500"
            case 501 :
                condition = "condition_501"
            case  502 :
                condition = "condition_502"
            case  503 :
                condition = "condition_503"
            case   504 :
                condition = "condition_504"
            case   511 :
                condition = "condition_511"
            case    520 :
                condition = "condition_520"
            case    531 :
                condition = "condition_531"
            case   600 :
                condition = "condition_600"
            case    601 :
                condition = "condition_601"
            case   602 :
                condition = "condition_602"
            case    611 :
                condition = "condition_611"
            case    612 :
                condition = "condition_612"
            case    615 :
                condition = "condition_615"
            case    616 :
                condition = "condition_616"
            case    620 :
                condition = "condition_620"
            case    621 :
                condition = "condition_621"
            case   622 :
                condition = "condition_622"
            case    701 :
                condition = "condition_701"
            case    711 :
                condition = "condition_711"
            case    721 :
                condition = "condition_721"
            case    731 :
                condition = "condition_731"
            case    741 :
                condition = "condition_741"
            case    751 :
                condition = "condition_751"
            case    761 :
                condition = "condition_761"
            case   762 :
                condition = "condition_762"
            case    771 :
                condition = "condition_771"
            case   781 :
                condition = "condition_781"
            case    800 :
                condition = "condition_800"
            case    801 :
                condition = "condition_801"
            case    802 :
                condition = "condition_802"
            case    803 :
                condition = "condition_803"
            case    804 :
                condition = "condition_804"
            case    900 :
                condition = "condition_900"
            case    901 :
                condition = "condition_901"
            case    902 :
                condition = "condition_902"
            case    903 :
                condition = "condition_903"
            case    904 :
                condition = "condition_904"
            case   905 :
                condition = "condition_905"
            case   906 :
                condition = "condition_906"
            case    951 :
                condition = "condition_951"
            case    952 :
                condition = "condition_952"
            case    953 :
                condition = "condition_953"
            case   954 :
                condition = "condition_954"
            case   955 :
                condition = "condition_955"
            case   956 :
                condition = "condition_956"
            case   957 :
                condition = "condition_957"
            case   958 :
                condition = "condition_958"
            case   959 :
                condition = "condition_959"
            case   960 :
                condition = "condition_960"
            case   961 :
                condition = "condition_961"
            case  962 :
                condition = "condition_962"
            default:
                break
        }
        return NSLocalizedString(condition, comment: condition)
    }
    
    /**
     * Helper method to provide the art resource ID according to the weather condition ID returned
     * by the OpenWeatherMap call. This method is very similar to
     *
     * [.getLargeArtResourceIdForWeatherCondition].
     *
     * The difference between these two methods is that this method provides larger assets, used
     * in the "today view" of the list, as well as in the DetailActivity.
     *
     * @param weatherId from OpenWeatherMap API response
     * See http://openweathermap.org/weather-conditions for a list of all IDs
     *
     * @return resource ID for the corresponding icon. -1 if no relation is found.
     */
    class func getLargeArtResourceIdForWeatherCondition(weatherId: Int) -> String {
        switch weatherId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
    
}
