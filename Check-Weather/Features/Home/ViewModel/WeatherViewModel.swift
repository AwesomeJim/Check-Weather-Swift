//
//  CurrentWeatherViewModel.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//


import Foundation
internal import Combine
import _LocationEssentials
import UIKit

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
    @Published var hourlyForecast: [WeatherItemModel] = []
    @Published var dailyForecast: [WeatherItemModel] = []
    
    /// True when a network request is in progress.
    @Published var isLoading: Bool = false
    
    /// Holds an error message to show to the user.
    @Published var errorMessage: AppError?
    
    @Published var currentIcon: UIImage?
    
    /// Stores [IconPath: DownloadedImage], e.g., ["10d": UIImage(...)]
    @Published var forecastIcons: [String: UIImage] = [:]
    
    @Published var searchText :String = ""
    
    let locationRequested = PassthroughSubject<Void, Never>()
    
    // MARK: - 2. Dependency (The "How")
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - 3. Initializer (Dependency Injection)
    
    /// We "inject" the network service when we create the ViewModel.
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    /// Sends the WeatherItemModel when a forecast item is tapped.
    let didTapForecastItem = PassthroughSubject<WeatherItemModel, Never>()
    

    /// This method is called by the SwiftUI view on tap.
    func forecastItemTapped(item: WeatherItemModel) {
        // Fires the signal, carrying the data model
        didTapForecastItem.send(item)
    }
    
    func searchButtonTapped() {
        // We READ the value that the user's typing has set
        guard !searchText.isEmpty else { return }
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        // We USE the value to run our logic
        fetchWeather(for: trimmed)
        self.searchText = ""
    }
    
    // MARK: - 4. Actions (Inputs)
    
    /// Fetches all weather data for a given city.
    func fetchWeather(for city: String) {
        
        // 1. Set loading state and clear old data/errors
        self.isLoading = true
        self.errorMessage = nil
        self.currentWeather = nil
        self.currentIcon = nil
        self.dailyForecast = []
        
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
                
                // Deconstruct the tuple
                let (hourly, daily) = try await forecastTask
                self.hourlyForecast = hourly
                self.dailyForecast = daily
                
                self.fetchIcon()
                self.fetchIconsForForecast()
                // 5. All done, stop loading.
                self.isLoading = false
                
            } catch {
                // 6. If anything went wrong, store the error
                self.errorMessage = AppError(title: "An Error Occurred", message:error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    /// Fetches all weather data for given coordinates.
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        self.isLoading = true
        self.errorMessage = nil
        self.currentWeather = nil
        self.currentIcon = nil
        self.dailyForecast = []
        
        Task {
            do {
                // Same concurrent fetch, but with coordinates
                async let currentTask = networkService.getCurrentWeather(lat: lat, lon: lon)
                async let forecastTask = networkService.getWeatherForecast(lat: lat, lon: lon)
                
                self.currentWeather = try await currentTask
                // Deconstruct the tuple
                let (hourly, daily) = try await forecastTask
                self.hourlyForecast = hourly
                self.dailyForecast = daily
                
                self.fetchIcon()
                self.fetchIconsForForecast()
                self.isLoading = false
                
            } catch {
                self.errorMessage = AppError(title: "An Error Occurred", message: error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    /// Triggers the download for the current weather's icon.
    func fetchIcon() {
        // Make sure we have weather data and an icon path
        guard let iconPath = currentWeather?.locationWeather.weatherConditionIcon else {
            AppUtils.logError("weatherConditionIcon is null")
            return
        }
        
        Task {
            do {
                // Call the new service method
                let iconData = try await networkService.downloadIcon(path: iconPath)
                
                // Update the @Published property
                self.currentIcon = UIImage(data: iconData)
                
            } catch {
                AppUtils.logError("Failed to download icon: \(error)")
                let iconName = currentWeather?.locationWeather.weatherConditionSfIcon
                self.currentIcon = UIImage(systemName:iconName ??   "cloud")
            }
        }
    }
    /// Fetches all unique icons for the current forecast list.
    func fetchIconsForForecast() {
        
        // 1. Get all unique icon paths from the forecast
        //    (Using Set avoids downloading "10d" 5 times)
        let allPaths = dailyForecast.map { $0.locationWeather.weatherConditionIcon }
        let uniquePaths = Set(allPaths)
        
        // 2. Clear old icons
        self.forecastIcons.removeAll()
        
        // 3. Start a new Task to run in the background
        Task {
            // 4. Use a TaskGroup to run multiple downloads at once
            //    This is the modern, fast way to do this!
            await withTaskGroup(of: (path: String, image: UIImage?).self) { group in
                
                for path in uniquePaths {
                    // Add a new download "job" to the group
                    group.addTask {
                        do {
                            let data = try await self.networkService.downloadIcon(path: path)
                            return (path, UIImage(data: data))
                        } catch {
                            AppUtils.logError("Failed to download forecast icon \(path): \(error)")
                            return (path, nil)
                        }
                    }
                }
                
                // 5. As each "job" finishes, collect its result
                for await (path, image) in group {
                    if let image = image {
                        // 6. Update our dictionary. This will trigger
                        //    our UI to update (see Step 2)
                        self.forecastIcons[path] = image
                    }
                }
            }
        }
    }
}
