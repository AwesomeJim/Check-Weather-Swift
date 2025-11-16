//
//  Response.swift
//  Check-Weather
//
//  Created by Awesome Jim on 09/09/2023.
//

import Foundation

struct WeatherItemModel: Codable {
    let locationName: String
    let locationId: Int
    let locationDate: Double
    let locationCoordinates: Coordinates
    let locationWeather: WeatherStatus
    let locationWeatherDay: Int
}



struct Coordinates: Codable{
    let longitude: Double
    let latitude: Double
}


struct WeatherStatus: Codable{
    let weatherConditionId: Int
    
    let weatherConditionIcon: String
    let weatherConditionDescription: String
    let weatherTemp: Double
    let weatherfeelsLike:Double
    let weatherTempMin: Double
    let weatherTempMax: Double
    let weatherPressure: Double
    let weatherHumidity: Int
    let weatherWind: Wind
    
    var weatherCondition: String {
        return WeatherUtils.getStringForWeatherCondition(weatherId: weatherConditionId)
    }
    // Computed values
    var weatherConditionSfIcon:String {
        return WeatherUtils.getLargeArtResourceIdForWeatherCondition(weatherId: weatherConditionId)
    }
    
    /// Returns the main temp rounded to an Int, as a String. E.g., "19"
    var weatherTempIntString: String {
        return String(format: "%.0f", weatherTemp)
    }
    
    /// Returns the 'feels like' temp rounded to an Int, as a String. E.g., "22"
    var feelsLikeIntString: String {
        return String(format: "%.0f", weatherfeelsLike)
    }
    
    /// Returns a combined string for High and Low temps. E.g., "High 24° • Low 16°"
    var highLowString: String {
        let high = String(format: "%.0f", weatherTempMax)
        let low = String(format: "%.0f", weatherTempMin)
        return "High \(high)° • Low \(low)°"
    }
    
}



struct Wind :Codable {
    let speed: Double
    let deg: Double
    
    // Computed values
    var windSpeedString:String {
        return WeatherUtils.getFormattedWind(windSpeed: speed, degrees: deg)
    }
}
