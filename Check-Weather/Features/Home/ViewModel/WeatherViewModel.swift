//
//  CurrentWeatherViewModel.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//


import Foundation
internal import Combine
import _LocationEssentials

// By marking the whole class with @MainActor, you guarantee
// that all property updates (the @Published ones) and
// all method calls happen on the main thread,
// which is required for UI updates.
@MainActor
class WeatherViewModel: ObservableObject {
    
    // MARK: - Dependencies & State
    // MARK: - 1. State Properties (Outputs)
    
    // @Published is a property wrapper that tells SwiftUI
    // to "watch" this property. When it changes, the
    // UI will automatically update.
    
    /// The current weather, or nil if not loaded.
    @Published var currentWeather: WeatherItemModel?
    
    /// The 5-day forecast list.
    @Published var forecast: [WeatherItemModel] = []
    
    /// True when a network request is in progress.
    @Published var isLoading: Bool = false
    
    /// Holds an error message to show to the user.
    @Published var errorMessage: String?
    
    // MARK: - 2. Dependency (The "How")
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - 3. Initializer (Dependency Injection)
    
    /// We "inject" the network service when we create the ViewModel.
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - 4. Actions (Inputs)
    
    /// Fetches all weather data for a given city.
    func fetchWeather(for city: String) {
        
        // 1. Set loading state and clear old data/errors
        self.isLoading = true
        self.errorMessage = nil
        self.currentWeather = nil
        self.forecast = []
        
        // 2. 'Task' is how you start an async operation
        //    from a non-async function.
        Task {
            do {
                // 3. This is the magic!
                //    'async let' starts BOTH network calls at the
                //    same time. This is much faster than
                //    waiting for the first one to finish.
                async let currentTask = networkService.getCurrentWeather(city: city)
                async let forecastTask = networkService.getWeatherForecast(city: city)
                
                // 4. Now we 'await' for both to finish and
                //    assign their results to our @Published properties.
                //    This will automatically trigger the UI to update.
                self.currentWeather = try await currentTask
                self.forecast = try await forecastTask ?? []
                
                // 5. All done, stop loading.
                self.isLoading = false
                
            } catch {
                // 6. If anything went wrong, store the error
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    /// Fetches all weather data for given coordinates.
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        self.isLoading = true
        self.errorMessage = nil
        self.currentWeather = nil
        self.forecast = []
        
        Task {
            do {
                // Same concurrent fetch, but with coordinates
                async let currentTask = networkService.getCurrentWeather(lat: lat, lon: lon)
                async let forecastTask = networkService.getWeatherForecast(lat: lat, lon: lon)
                
                self.currentWeather = try await currentTask
                self.forecast = try await forecastTask ?? []
                self.isLoading = false
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
