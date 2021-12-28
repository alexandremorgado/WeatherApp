//
//  Location.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation
 
// Weather model according to Location API
struct Location {
    let woeid: Int
    let title: String
}

extension Location: Decodable { }
