//
//  WeatherResponse.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation

// 1. The Top-Level API Response Object
struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind 
    let dt: Double
    let id: Int
    let name: String
    let visibility: Int
}

// 2. The 'coord' object
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// 3. The 'main' object
struct Main: Codable {
    let temp: Double
    let feelsLike: Double // Decoded from "feels_like"
    let tempMin: Double // Mapped from "temp_min"
    let tempMax: Double // Mapped from "temp_max"
    let pressure: Double
    let humidity: Int
}

// 4. The 'weather' array
struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}
