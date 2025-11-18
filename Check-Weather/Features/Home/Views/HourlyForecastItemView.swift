//
//  ForecastItemView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 17/11/2025.
//

import SwiftUI

struct HourlyForecastItemView: View {
    
    var item: WeatherItemModel
    var icon: UIImage?
    
    var body: some View {
        VStack(spacing: 12) {
            // "16°"
            Text("\(item.locationWeather.weatherTempIntString)°")
                .font(.title3)
                .fontWeight(.semibold)
            
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
            // "3 AM"
            Text(item.hourOfDay)
                .font(.caption)
        
        }
        .foregroundColor(.white)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
    }
}
