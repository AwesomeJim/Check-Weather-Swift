//
//  ForecastView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 17/11/2025.
//

import SwiftUI

struct HourlyForecastView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        // 1. ZStack for the glass background
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 16) {
                // 2. Header
                HStack {
                    Image(systemName: "timer")
                        .font(.headline)
                    Text("Hourly Forecast")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .opacity(0.7) // Make it a bit more subtle
                
                // 3. Horizontal Scrolling List
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        
                        // 4. Loop over the 3-hour forecast
                        ForEach(viewModel.hourlyForecast, id: \.locationDate) { item in
                            
                            // 5. Get the icon for this item
                            let icon = viewModel.forecastIcons[item.locationWeather.weatherConditionIcon]
                            
                            // 6. Create the item view
                            HourlyForecastItemView(item: item, icon: icon)
                        }
                    }
                }
            }
            .padding(20) // Padding inside the glass
        }
    }
}

// --- PREVIEW ---
// Add this so you can preview your forecast view
struct ForecastView_Previews: PreviewProvider {
    
    // Helper to make a VM with mock data
    static func makeMockViewModel() -> WeatherViewModel {
        let vm = WeatherViewModel(networkService: MockNetworkService())
        
        vm.hourlyForecast = MockNetworkService.mockForecastTuple.hourly
        
        // Add a mock icon to the dictionary
        vm.forecastIcons["02d"] = UIImage(systemName: "cloud.sun.fill")
        
        return vm
    }
    
    static var previews: some View {
        ZStack {
            // Simulate the blue-ish background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.7), .blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            HourlyForecastView(viewModel: makeMockViewModel())
                .padding()
        }
    }
}
