//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var weathers: [Weather] = []

}
