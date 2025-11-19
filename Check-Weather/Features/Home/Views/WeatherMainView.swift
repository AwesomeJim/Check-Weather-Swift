//
//  WeatherMainView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 18/11/2025.
//

import SwiftUI

struct WeatherMainView: View {
    
    // The entire view observes the one source of truth
    @ObservedObject var viewModel: WeatherViewModel
    
    
    var body: some View {
        // 3. Wrap the ScrollView in a ZStack
        ZStack {
            
            // 4. Place the dynamic background in the back
            ThemeBackground()
                           .edgesIgnoringSafeArea(.all)
            // 1. Master Scroll View (Replaces UIKit's ScrollView)
            ScrollView(.vertical, showsIndicators: false) {
                
                // 2. Master VStack (Replaces UIKit's UIStackView)
                VStack(spacing: 16) {
                    
                    // --- Top Section: Search Bar (Pinned to Top) ---
                    SearchBarView(viewModel: viewModel)
                        .padding(.top, 38) // Push content below the notch/status bar
                    
                    // --- Current Weather ---
                    CurrentWeatherView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // --- Hourly Forecast ---
                    HourlyForecastView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // --- 5-Day Forecast ---
                    DayForecastView(viewModel: viewModel)
                        .padding(.horizontal)
                        .padding(.bottom, 16) // Add padding at the bottom for scrolling clearance
                    
                    if let weather = viewModel.currentWeather {
                        WeatherDetailGrid(weather: weather)
                            .padding(.horizontal)
                            .padding(.bottom, 40) // Extra padding for scrolling
                    }
                }
                // 3. Set the background color to match your target dark theme
                .frame(maxWidth: .infinity)
            }
            // This view handles all the layout logic perfectly!
        }
    }
}


// --- PREVIEW ---
// Updated to show both themes
struct WeatherMainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherMainView(viewModel: CurrentWeatherView_Previews.makeLoadedViewModel())
                .previewDisplayName("1. Dark Mode (Grey Gradient)")
                .preferredColorScheme(.dark)
            
            WeatherMainView(viewModel: CurrentWeatherView_Previews.makeLoadedViewModel())
                .previewDisplayName("2. Light Mode (Blue Gradient)")
                .preferredColorScheme(.light)
        }
    }
}
