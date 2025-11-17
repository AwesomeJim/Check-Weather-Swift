//
//  SearchBarView.swift
//  Check-Weather
//
//  Created by Awesome Jim on 17/11/2025.
//

import SwiftUI

struct SearchBarView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            
            // 2. Location Button
            Button(action: {
                // Send the "location requested" signal
                viewModel.locationRequested.send()
            }) {
                Image(systemName: "location.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            // 3. Search TextField
            TextField("Search", text: $viewModel.searchText, onCommit: {
                // 'onCommit' is when the user hits 'return'
                viewModel.searchButtonTapped()
            })
            .padding(10)
            .padding(.leading, 10) // Add some space for text
            .background(Color.white.opacity(0.2)) // Translucent white
            .cornerRadius(10)
            
            // 4. Search Button
            Button(action: {
                // Call the search action
                viewModel.searchButtonTapped()
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal) // Add padding to the whole bar
        .padding(.vertical, 8)
        .cornerRadius(20)
    }
}

// --- PREVIEW ---
// Add this so you can preview your search bar!
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        // We create a mock VM just for the preview
        let vm = WeatherViewModel(networkService: MockNetworkService())
        
        ZStack {
            // Simulate the blue-ish background
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.7), .blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            SearchBarView(viewModel: vm)
        }
    }
}
