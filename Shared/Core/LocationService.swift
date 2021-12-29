//
//  LocationService.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation
import MapKit

enum LocationParams {
    case query(String)
    case coordinate(latitude: Double, longitude: Double)
}

/**
    LocationService fetches locations from MetaWeather API
*/
struct LocationService {
    
    static func fetchLocation(byText query: String) async throws -> [Location] {
        var urlComponents = URLComponents(string: "https://www.metaweather.com/api/location/search")
        urlComponents?.queryItems = [URLQueryItem(name: "query", value: query)]
        guard let url = urlComponents?.url else { throw URLError(.badURL) }
        let locations = try await LocationService.fetchLocations(url: url)
        guard locations.count > 0 else {
            let placemarks = try await LocationService.fetchPlacemark(query: query)
            guard let coordinate = placemarks.first?.coordinate else { return [] }
            return try await LocationService.fetchLocation(byLatitude: coordinate.latitude, andLongitude: coordinate.longitude)
        }
        return locations
    }
    
    static func fetchLocation(byLatitude latitude: Double, andLongitude longitude: Double) async throws -> [Location] {
        let urlString = "https://www.metaweather.com/api/location/search?lattlong=\(latitude),\(longitude)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        return try await LocationService.fetchLocations(url: url)
    }
    
    private static func fetchLocations(url: URL) async throws -> [Location] {
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let locations = try LocationService.locationDecoder.decode([Location].self, from: data)
            return locations
        } catch {
            throw error
        }
    }
    
    private static func fetchPlacemark(query: String) async throws -> [MKPlacemark] {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let localSearch = MKLocalSearch(request: searchRequest)
        let searchResponse = try await localSearch.start()
        return searchResponse.mapItems.map{$0.placemark}
    }
    
}

extension LocationService {
    private static let locationDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
}
