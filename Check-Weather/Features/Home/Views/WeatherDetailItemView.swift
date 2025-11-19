//
//  WeatherDetailItemView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 19/11/2025.
//

import SwiftUI

// 1. The Single Square Card
struct WeatherDetailItem: View {
    var icon: String
    var title: String
    var value: String
    var subValue: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white.opacity(0.7))
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Value
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            // Optional Footer (e.g., "Dew point")
            if let sub = subValue {
                Text(sub)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 140) // Square-ish height
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        )
        .cornerRadius(20)
    }
}

// 2. The Grid Container
struct WeatherDetailGrid: View {
    var weather: WeatherItemModel
    
    // Define a 2-column grid layout
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            
            // 1. Wind
            WeatherDetailItem(
                icon: "wind",
                title: "Wind",
                value: weather.locationWeather.weatherWind.windSpeedString
            )
            
            // 2. Sunrise & Sunset
            WeatherDetailItem(
                icon: "sunrise.fill",
                title: "Sunrise",
                value: weather.locationWeather.sunriseString,
                subValue: "Sunset: \(weather.locationWeather.sunsetString)"
            )
            
            // 3. Visibility
            WeatherDetailItem(
                icon: "eye.fill",
                title: "Visibility",
                value: weather.locationWeather.visibilityString
            )
            
            // 4. Humidity
            WeatherDetailItem(
                icon: "humidity",
                title: "Humidity",
                value: weather.locationWeather.humidityString
            )
            
            // 5. Pressure
            WeatherDetailItem(
                icon: "gauge",
                title: "Pressure",
                value: weather.locationWeather.pressureString
            )
            
            // 6. Precipitation (PoP)
            WeatherDetailItem(
                icon: "cloud.rain.fill",
                title: "Precipitation",
                value: weather.locationWeather.popString,
                subValue: "Chance of rain"
            )
        }
    }
}
