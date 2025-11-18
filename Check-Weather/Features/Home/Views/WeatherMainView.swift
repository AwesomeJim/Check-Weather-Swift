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
        // 1. Master Scroll View (Replaces UIKit's ScrollView)
        ScrollView(.vertical, showsIndicators: false) {
            
            // 2. Master VStack (Replaces UIKit's UIStackView)
            VStack(spacing: 16) {
                
                // --- Top Section: Search Bar (Pinned to Top) ---
                SearchBarView(viewModel: viewModel)
                    .padding(.top, 60) // Push content below the notch/status bar
                
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
        // 4. Set the general background of the ScrollView
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        // 5. Ignore the top safe area only for the content to start high up,
        //    but the padding on the SearchBarView brings it down safely.
        .edgesIgnoringSafeArea(.top)
        
        // This view handles all the layout logic perfectly!
    }
}

// --- PREVIEW ---
struct WeatherMainView_Previews: PreviewProvider {
    static var previews: some View {
        // Use the mock VM to see the entire screen rendered
        WeatherMainView(viewModel: CurrentWeatherView_Previews.makeLoadedViewModel())
            .preferredColorScheme(.dark)
    }
}
