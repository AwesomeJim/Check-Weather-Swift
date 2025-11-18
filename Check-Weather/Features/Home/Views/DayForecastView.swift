//
//  DayForecastView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 18/11/2025.
//

import SwiftUI

struct DayForecastView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        // 1. ZStack for the glass background
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 16) {
                // 2. Header
                HStack {
                    Image(systemName: "calendar")
                        .font(.headline)
                    Text("5-Day forecast")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .opacity(0.7)
                
                // 3. Horizontal Scrolling List
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        
                        // 4. Loop over the 3-hour forecast
                        ForEach(viewModel.dailyForecast, id: \.locationDate) { item in
                            
                            // 5. Get the icon for this item
                            let icon = viewModel.forecastIcons[item.locationWeather.weatherConditionIcon]
                            
                            // 6. Create the item view
                            ForecastItemView(item: item, icon: icon)
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
struct DayForecastView_Previews: PreviewProvider {
    
    // Helper to make a VM with mock data
    static func makeMockViewModel() -> WeatherViewModel {
        let vm = WeatherViewModel(networkService: MockNetworkService())
        
        
        vm.dailyForecast = MockNetworkService.mockForecastTuple.daily
        
        // Add a mock icon to the dictionary
        vm.forecastIcons["10d"] = UIImage(systemName: "cloud.sun.fill")?
            .withRenderingMode(.alwaysOriginal)
        
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
            
            DayForecastView(viewModel: makeMockViewModel())
                .padding()
        }
    }
}
