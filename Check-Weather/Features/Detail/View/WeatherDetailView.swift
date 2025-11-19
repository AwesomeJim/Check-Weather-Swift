//
//  WeatherDetailView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 19/11/2025.
//

import SwiftUI

struct WeatherDetailView: View {
    
    var weather: WeatherItemModel
    
    // Used to dismiss the sheet
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // 1. Background (Dark Grey Gradient)
            ThemeBackground()
                           .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 2. Header Section
                    VStack(spacing: 8) {
                        // Pull Bar indicator
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 40, height: 6)
                            .padding(.top, 10)
                        
                        Text(weather.locationName)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                        
                        Text(weather.dayOfWeek) // e.g., "Monday"
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(weather.dayAndMonth) // e.g. "18/11"
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // 3. Main Weather Info
                    VStack(spacing: 0) {
                        // You would typically pass the icon image here too,
                        // but for now we can show the description
                        Text(weather.locationWeather.weatherConditionDescription.capitalized)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("\(weather.locationWeather.weatherTempIntString)°")
                            .font(.system(size: 90, weight: .thin))
                            .foregroundColor(.white)
                        
                        Text(weather.locationWeather.highLowString)
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 20)
                    
                    // 4. THE REUSABLE GRID!
                    WeatherDetailGrid(weather: weather)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

// --- PREVIEW ---
struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weather: MockNetworkService.mockWeather)
    }
}
