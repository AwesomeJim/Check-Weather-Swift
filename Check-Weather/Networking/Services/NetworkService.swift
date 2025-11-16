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
    
    
    // MARK: - Core Fetch Function (Generic and Reusable)
    /// This is your NEW fetch function. It's now truly generic and
    /// handles all decoding.
    private func fetch<T: Decodable>(url: URL) async throws -> T {
        
        // 1. Create URLComponents from your base URL
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            // You'll want to define this custom error
            throw NetworkError.invalidURL
        }
        
        // 2. Create the API key query item
        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: NetworkUtilsEnum.APP_ID_PARAM, value: AppConfig.openWeatherAPIKey))
        queryItems.append(URLQueryItem(name: NetworkUtilsEnum.UNITS_PARAM, value: NetworkUtilsEnum.units))
        
        
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
        
        print("response :\n \(data)")
        // 2. Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Throw a custom error if the status code is bad (e.g., 401, 404, 500)
            throw NetworkError.invalidResponse
        }
    
        do {
            let decoder = JSONDecoder()
            // This is the magic trick for "temp_min", "temp_max", etc.
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            // This helps you debug decoding errors
            AppUtils.logError("Decoding Error: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
    
    /// A generic helper that fetches data, logs the response, maps it, logs the result, and returns it.
    private func fetchAndMap<ResponseType: Decodable, MappedType>(
        url: URL,
        mapper: (ResponseType) -> MappedType, // The mapping function to pass in
        logContext: String                   // A string for clear logging
    ) async throws -> MappedType {
        
        // 1. Fetch
        // The type 'ResponseType' is inferred by the 'fetch' function
        let response: ResponseType = try await fetch(url: url)
        AppUtils.logInfo("Raw \(logContext) response: \(response)")
        
        // 2. Map
        let mappedData = mapper(response)
        
        // 3. Log
        if let dataList = mappedData as? [Any] {
            AppUtils.logInfo("Mapped \(logContext) items: \(dataList.count)")
        } else {
            AppUtils.logInfo("Mapped \(logContext) data: \(mappedData)")
        }
        
        // 4. Return
        return mappedData
    }
    
    class func downloadWeatherIcon(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: OpenWeatherApiClient.Endpoints.weatherIcon(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    // MARK: - Public API Methods (from Protocol)
    
    func getCurrentWeather(city: String) async throws -> WeatherItemModel? {
        return try await fetchAndMap(
                url: Endpoints.weatherCity(city).url,
                mapper: WeatherMapper.mapWeatherResponse,
                logContext: "CurrentWeather"
            )
    }
    
    func getWeatherForecast(city: String) async throws -> [WeatherItemModel]? {
        return try await fetchAndMap(
                url: Endpoints.forecastCity(city).url,
                mapper: WeatherMapper.mapForecastResponse, // Pass the function
                logContext: "Forecast"
            )
    }
    
    func getCurrentWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> WeatherItemModel? {
        return try await fetchAndMap(
                url: Endpoints.weatherCoordinates(lat: lat, lon: lon).url,
                mapper: WeatherMapper.mapWeatherResponse,
                logContext: "CurrentWeather"
            )
    }
    
    func getWeatherForecast(lat: CLLocationDegrees, lon: CLLocationDegrees) async throws -> [WeatherItemModel]?{
        return try await fetchAndMap(
                url: Endpoints.forecastCoordinates(lat: lat, lon: lon).url,
                mapper: WeatherMapper.mapForecastResponse,
                logContext: "Forecast"
            )
    }
    
    
}
