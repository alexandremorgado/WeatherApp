//
//  LocationService.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

/**
    LocationService fetches locations from MetaWeather API
*/
struct LocationService {
    
    static func fetchLocation(byText query: String) async throws -> [Location] {
        let urlString = "https://www.metaweather.com/api/location/search/?query=\(query)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        return try await LocationService.fetchLocations(url: url)
    }
    
    static func fetchLocation(byLatitude latitude: Double, and longitude: Double) async throws -> [Location] {
        let urlString = "https://www.metaweather.com/api/location/search?lattlong=\(latitude),\(longitude)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        return try await LocationService.fetchLocations(url: url)
    }
    
    static func fetchLocations(url: URL) async throws -> [Location] {
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let locations = try JSONDecoder().decode([Location].self, from: data)
            return locations
        } catch {
            throw error
        }
    }
    
}
