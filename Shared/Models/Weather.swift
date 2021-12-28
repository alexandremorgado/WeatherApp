//
//  Weather.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

struct Weather: Identifiable, Equatable {
    let id: Int
    let maxTemp: Double
    let minTemp: Double
    let theTemp: Double
    
}

extension Weather: Codable {
    
}

