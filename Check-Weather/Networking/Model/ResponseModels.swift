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
    var locationDate: Double
    let locationCoordinates: Coordinates
    let locationWeather: WeatherStatus
    let locationWeatherDay: Int
    
    /// Formats the timestamp to a short day name, e.g., "Mon"
    var dayOfWeek: String {
        let date = Date(timeIntervalSince1970: locationDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // "E" = Mon, "EEEE" = Monday
        return formatter.string(from: date)
    }
    
    /// Formats the timestamp to a short hour, e.g., "3 AM"
    var hourOfDay: String {
        let date = Date(timeIntervalSince1970: locationDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "h a" // "h" = 3, "a" = AM/PM
        return formatter.string(from: date).uppercased()
    }
    /// Formats the timestamp to Day/Month, e.g., "18/11"
    var dayAndMonth: String {
        let date = Date(timeIntervalSince1970: locationDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM" // dd = Day (18), MM = Month (11)
        return formatter.string(from: date)
    }
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
    let weatherfeelsLike:Double
    let weatherTempMin: Double
    let weatherTempMax: Double
    let weatherPressure: Double
    let weatherHumidity: Int
    let weatherWind: Wind
    let visibility: Int
    let pop: Double?
    let sunrise: Double
    let sunset: Double
    
    var weatherCondition: String {
        return WeatherUtils.getStringForWeatherCondition(weatherId: weatherConditionId)
    }
    // Computed values
    var weatherConditionSfIcon:String {
        return WeatherUtils.getLargeArtResourceIdForWeatherCondition(weatherId: weatherConditionId)
    }
    
    /// Returns the main temp rounded to an Int, as a String. E.g., "19"
    var weatherTempIntString: String {
        return String(format: "%.0f", weatherTemp)
    }
    
    /// Returns the 'feels like' temp rounded to an Int, as a String. E.g., "22"
    var feelsLikeIntString: String {
        return String(format: "%.0f", weatherfeelsLike)
    }
    
    /// Returns a combined string for High and Low temps. E.g., "High 24° • Low 16°"
    var highLowString: String {
        let high = String(format: "%.0f", weatherTempMax)
        let low = String(format: "%.0f", weatherTempMin)
        return "High \(high)° • Low \(low)°"
    }
    
    /// Formats the 'pop' value (0.0 to 1.0) as a percentage string, e.g., "15%"
    var popString: String {
        // Use 0% as a default if pop is nil
        guard let pop = pop else { return "0%" }
        let percent = Int(pop * 100)
        return "\(percent)%"
    }
    
    var sunriseString: String {
        return formatTime(sunrise)
    }
    
    var sunsetString: String {
        return formatTime(sunset)
    }
    
    var pressureString: String {
        return String(format: "%.0f hPa", weatherPressure)
    }
    
    var humidityString: String {
        return "\(weatherHumidity)%"
    }
    
    var visibilityString: String {
        // Convert meters to km (or miles)
        let km = Double(visibility) / 1000.0
        return String(format: "%.1f km", km)
    }
    
    private func formatTime(_ timestamp: Double) -> String {
        if timestamp == 0 { return "--:--" }
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short // e.g., "6:13 AM"
        return formatter.string(from: date)
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
