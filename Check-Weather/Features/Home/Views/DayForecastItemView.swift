//
//  DayForecastItemView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 17/11/2025.
//

import SwiftUI

struct ForecastItemView: View {
    
    // ViewModel is now required to trigger the tap action
    @ObservedObject var viewModel: WeatherViewModel
    
    var item: WeatherItemModel
    var icon: UIImage?
    
    var body: some View {
        VStack(spacing: 12) {
            // "16°"
            Text("\(WeatherUtils.formatTemperature(temperature: item.locationWeather.weatherTempMax))")
                .font(.title3)
                .fontWeight(.semibold)
            Text("\(WeatherUtils.formatTemperature(temperature: item.locationWeather.weatherTempMin))")
                .font(.title3)
                .fontWeight(.regular)
                .opacity(0.7)
            // Icon
            if let icon = icon {
                Image(uiImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 45)
            } else {
                // Placeholder
                ProgressView()
                    .frame(width: 45, height: 45)
            }
            Text(item.locationWeather.popString)
                .font(.caption)
                .fontWeight(.bold)
            // "Mon"
            Text(item.dayOfWeek)
                .font(.headline)
                .fontWeight(.medium)
            
            // "3 AM"
            Text(item.dayAndMonth)
                .font(.caption)
                .opacity(0.7)
        }
        .foregroundColor(.white)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.1)) // Subtle background for the card
        .cornerRadius(20)
        .onTapGesture {
                    // Call the ViewModel method, passing the tapped item
                    viewModel.forecastItemTapped(item: item)
                }
    }
}
