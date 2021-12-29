//
//  Location.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation
import CoreLocation
 
// MARK: - Location model according to MetaWeather API

struct Location: Identifiable, Equatable {
    let woeid: Int
    let title: String
    let lattLong: String
    
    var id: Int { woeid }
}

// MARK: - Computed properties

extension Location {
    
    var coordinate: CLLocationCoordinate2D? {
        let coordComponents = lattLong.components(separatedBy: ",")
        guard let latString = coordComponents.first,
              let longString = coordComponents.last,
              let lat = Double(latString),
              let long = Double(longString)
        else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}

// MARK: - Codable

extension Location: Decodable { }

// MARK: - Mock

extension Location {
    static var sample: Location {
        Location(woeid: 44418, title: "London", lattLong: "51.506321,-0.12714")
    }
}
