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
    let weatherCondition: String
    let weatherConditionDescription: String
    let weatherTemp: Double
    let weatherTempMin: Double
    let weatherTempMax: Double
    let weatherPressure: Double
    let weatherHumidity: Int
    let weatherWind: Wind
}



struct Wind :Codable {
    let speed: Double
    let deg: Double
}
