//
//  ThemeBackground.swift
//  Check-Weather
//
//  Created by Awesome Jim on 19/11/2025.
//

import SwiftUI

struct ThemeBackground: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
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
}

struct ThemeBackground_Previews: PreviewProvider {
    static var previews: some View {
        ThemeBackground()
    }
}
