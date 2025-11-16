//
//  NetworkServiceProtocol.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation
import CoreLocation

// Define your protocol
protocol NetworkServiceProtocol {
    /// Fetches the current weather for a specific city.
    func getCurrentWeather(city: String) async throws -> WeatherItemModel?
    
    /// Fetches the 5-day weather forecast for a specific city.
    func getWeatherForecast(city: String) async throws -> [WeatherItemModel]?
    
    /// Fetches the current weather for specific coordinates.
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> WeatherItemModel?
    
    /// Fetches the 5-day weather forecast for specific coordinates.
    func getWeatherForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> [WeatherItemModel]?
}
