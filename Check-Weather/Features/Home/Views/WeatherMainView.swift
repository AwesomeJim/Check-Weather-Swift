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
    
    // 1. Detect the current system color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // 2. Computed property that returns the correct background for the theme
    var dynamicBackground: some View {
        // Define Dark Mode Gradient
        let darkGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.1), // Near Black/Dark Grey
                Color(red: 0.05, green: 0.05, blue: 0.05) // Deeper Black/Grey
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Define Light Mode Gradient
        let lightGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.3, blue: 0.7),
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Return the correct gradient based on the environment
        if colorScheme == .dark {
            return darkGradient
        } else {
            // Use the blue theme for light mode to look more like a classic weather app
            return lightGradient
        }
    }
    
    var body: some View {
        // 3. Wrap the ScrollView in a ZStack
        ZStack {
            
            // 4. Place the dynamic background in the back
            dynamicBackground
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
                        .padding(.bottom, 20) // Add padding at the bottom for scrolling clearance
                    
                    // You can add other views here easily, like an About or Details card.
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
