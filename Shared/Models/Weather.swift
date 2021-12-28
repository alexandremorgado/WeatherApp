//
//  Weather.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

// Weather model according to MetaWeather API
struct Weather: Identifiable, Equatable {
    let id: Int
    let applicableDate: Date
    let maxTemp: Double
    let minTemp: Double
    let theTemp: Double
    let weatherStateName: String
    let weatherStateAbbr: String
    let airPressure: Double
    let humidity: Double
    let predictability: Double
}

extension Weather: Decodable { }

struct LocationWeather: Decodable {
    let consolidatedWeather: [Weather]
}
