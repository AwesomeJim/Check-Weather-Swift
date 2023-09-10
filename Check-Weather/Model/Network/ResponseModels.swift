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
    
    
    var weatherTempString: String {
        let temp =  String(format: "%.1f", weatherTemp)
        return temp //WeatherUtils.formatTemperature(temperature: weatherTemp)
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
