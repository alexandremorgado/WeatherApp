//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

/**
    WeatherService fetches weather information from MetaWeather API
*/
struct WeatherService {
    
    static func fetchWeather(location: Location) async throws -> [Weather] {
        let urlString = "https://www.metaweather.com/api/location/\(location.woeid)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let locationWeather = try WeatherService.weatherDecoder.decode(LocationWeather.self, from: data)
            return locationWeather.consolidatedWeather
        } catch {
            throw error
        }
    }
}

extension WeatherService {
    private static let weatherDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
}
