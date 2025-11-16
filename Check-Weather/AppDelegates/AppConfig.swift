//
//  AppConfig.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation

struct AppConfig {
    // Retrieves the API Key from Info.plist
    static var openWeatherAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("openWeatherAPIKey must be set in Info.plist (via .xcconfig)")
        }
        return key
    }
        
    
    //Other necessary constants (like the USD UUID)
    static let defaultReferenceCurrencyUUID: String = "yhjMzLPhuIDl"
}
