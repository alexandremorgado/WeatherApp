//
//  ViewStatus.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

enum ViewStatus: Equatable {
    case idle
    case fetchingLocations
    case locationsLoaded([Location])
    case fetchingWeather
    case weathersLoaded([Weather], location: Location)
    case fetchingCurrentLocation
    case empty
    case error(message: String)
}
