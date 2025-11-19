//
//  AppError.swift
//  Check-Weather
//
//  Created by Awesome Jim on 16/11/2025.
//

import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}
