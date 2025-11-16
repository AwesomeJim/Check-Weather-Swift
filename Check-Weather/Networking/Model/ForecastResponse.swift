//
//  ForecastResponse.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation

// MARK: - Forecast Response Models

// 1. The Top-Level Forecast Response Object
struct ForecastResponse: Codable {
    /// A list of 3-hour forecast items.
    let list: [ForecastItem]
    /// Information about the city.
    let city: City
}

// 2. An item within the "list" array
struct ForecastItem: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    /// The timestamp (dt) for this forecast item
    let dt: Double
}

// 3. The "city" object
struct City: Codable {
    let id: Int
    let name: String
    /// The 'coord' object (lat, lon)
    let coord: Coord
}
