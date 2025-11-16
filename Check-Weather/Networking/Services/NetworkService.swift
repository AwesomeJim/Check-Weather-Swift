//
//  NetworkService.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation
import _LocationEssentials

// The main Network Service implementation
class NetworkService: NetworkServiceProtocol {
    
    
    // Base URL for the CoinRanking API
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/")!
    
    // MARK: - Helper: Endpoints
    enum Endpoints {
        static let base = "https://api.openweathermap.org/data/2.5/"
        static let imageBase = "https://openweathermap.org/img/wn/"
        
        
        case weatherCity(String)
        case forecastCity(String)
        case weatherCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
        case forecastCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees)
        case weatherIcon(String)
        
        var stringValue: String {
            switch self {
            case .weatherCity(let cityName): return Endpoints.base + "weather?\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                
            case .forecastCity(let cityName): return Endpoints.base + "forecast?\(NetworkUtilsEnum.QUERY_PARAM)=\(cityName)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                
            case .weatherCoordinates(let lat, let lag): return Endpoints.base + "weather?\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                
            case .forecastCoordinates(let lat, let lag): return Endpoints.base + "forecast?\(NetworkUtilsEnum.LAT_PARAM)=\(lat)&\(NetworkUtilsEnum.LON_PARAM)=\(lag)&\(NetworkUtilsEnum.UNITS_PARAM)=\(NetworkUtilsEnum.units)"
                
            case .weatherIcon(let icon): return Endpoints.imageBase + "\(icon)@2x.png"
            }
        }
        
        var url: URL {
            print(stringValue)
            return URL(string: stringValue)!
        }
    }
    
    // MARK: - Helper: Forecast Response
    /// The /forecast endpoint returns an object with a "list" key.
    /// This struct is used to decode that top-level object.
    struct ForecastResponse: Codable {
        let list: [WeatherItemModel]
    }
    // MARK: - Core Fetch Function (Generic and Reusable)
    
    // This is a generic function that handles the decoding for any Codable type
    private func fetch(url: URL) async throws -> String {
        
        // 1. Create URLComponents from your base URL
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            // You'll want to define this custom error
            throw NetworkError.invalidURL
        }
        
        // 2. Create the API key query item
        let apiKeyItem = URLQueryItem(name: "appid", value: AppConfig.openWeatherAPIKey)
        
        // 3. Add it to the components
        // If components.queryItems is nil, create a new array
        var queryItems = components.queryItems ?? []
        queryItems.append(apiKeyItem)
        components.queryItems = queryItems
        
        // 4. Get the final URL with the new query parameter
        guard let finalUrl = components.url else {
            throw NetworkError.invalidURL
        }
        
        AppUtils.logInfo("finalUrl : \(finalUrl)")
        var request = URLRequest(url: finalUrl)
        request.httpMethod = "GET"
        
        
        // 1. Perform the network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 2. Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Throw a custom error if the status code is bad (e.g., 401, 404, 500)
            throw NetworkError.invalidResponse
        }
        
        do {
            let responseString = String(data: data, encoding: .utf8)
            return responseString ?? "{}"
        } catch {
            AppUtils.logError("Failed to fetch coins: \(error.localizedDescription)")
            // Throw a custom error if decoding fails
            throw NetworkError.decodingError(error)
        }
        
//        // 4. Convert the 'Data' object to a 'String'
//        //    We use .utf8 encoding, which is standard for JSON.
//        guard let responseString = String(data: data, encoding: .utf8) else {
//            // This would fail if the data wasn't valid text
//            throw NetworkError.decodingError(<#any Error#>)// Or a more specific error
//        }
//        
//        // 5. Return the raw string
//        return responseString
    }
    
    
    // MARK: - Public API Methods (from Protocol)
    
    func getCurrentWeather(city: String) async throws -> WeatherItemModel? {
        // Use the generic fetch for the 'current' endpoint
        let responseString  = try await fetch(url: Endpoints.weatherCity(city).url)
        AppUtils.logInfo("getCurrentWeather responseString \n: \(responseString)")
        let weatherDataModel = OpenWeatherJsonUtils.getWeatherContentValuesFromJson(weatherData: responseString)
        AppUtils.logInfo("Model Data. locationName = \(String(describing: weatherDataModel?.locationName))")
        return weatherDataModel
    }
    
    func getWeatherForecast(city: String) async throws -> [WeatherItemModel]? {
        // Use the generic fetch for the 'forecast' endpoint
        let responseString = try await fetch(url: Endpoints.forecastCity(city).url)
        AppUtils.Log(from:self,with:"Model Data. forecastResponse = \(String(describing: responseString))")
        print("responseString : \(responseString)")
        let weatherForeCastList = OpenWeatherJsonUtils.getWeatherForecastContentValuesFromJson(weatherData: responseString)
        AppUtils.logInfo("Model Data. ForecastItems = \(String(describing: weatherForeCastList?.count))")
        return weatherForeCastList
    }
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> WeatherItemModel? {
        let responseString  = try await fetch(url: Endpoints.weatherCoordinates(lat: lat, lon: lon).url)
        AppUtils.logInfo("responseString :\n \(responseString)")
        let weatherDataModel = OpenWeatherJsonUtils.getWeatherContentValuesFromJson(weatherData: responseString)
        AppUtils.logInfo("Model Data. locationName = \(String(describing: weatherDataModel?.locationWeather.weatherTemp))")
        return weatherDataModel
    }
    
    func getWeatherForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> [WeatherItemModel]?{
        let responseString = try await fetch(url: Endpoints.forecastCoordinates(lat: lat, lon: lon).url)
        AppUtils.logInfo("Model Data. forecastResponse = \(responseString))")
        let weatherForeCastList = OpenWeatherJsonUtils.getWeatherForecastContentValuesFromJson(weatherData: responseString)
        AppUtils.logInfo("Model Data. ForecastItems = \(weatherForeCastList?.count)")
        return weatherForeCastList
    }
    
}
