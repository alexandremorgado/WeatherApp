//
//  Weather.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

// MARK: - Weather model according to MetaWeather API

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

// MARK: - Computed properties

extension Weather {
    
    var fahrenheitTemp: Double {
        (theTemp * 1.8) + 32
    }
    
    var fahrenheitTempFormatted: String {
        "\(Int(fahrenheitTemp))"
    }
    
    var celsiusTempFormatted: String {
        "\(Int(theTemp))"
    }
    
    var predictabilityFormatted: String {
        "\(predictability)"
    }
    
    var airPressureFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formattedValue = formatter.string(from: NSNumber(value: airPressure)) ?? "\(Int(airPressure))"
        return "\(formattedValue) hPa"
    }
    
    var humidityFormatted: String {
        "\(Int(humidity))%"
    }
    
    var iconUrlString: String {
        "https://www.metaweather.com//static/img/weather/png/64/\(weatherStateAbbr).png"
    }
    
    var iconURL: URL? {
        URL(string: iconUrlString)
    }
    
}

// MARK: - Codable

extension Weather: Decodable { }

struct LocationWeather: Decodable {
    let consolidatedWeather: [Weather]
}

// MARK: - Mock

extension Weather {
    static var sample: Weather {
        Weather(
            id: 5367191965794304,
            applicableDate: Date(),
            maxTemp: 14.415,
            minTemp: 12.280000000000001,
            theTemp: 13.93,
            weatherStateName: "Heavy Cloud",
            weatherStateAbbr: "hc",
            airPressure: 1014.5,
            humidity: 89,
            predictability: 71
        )
    }
}
