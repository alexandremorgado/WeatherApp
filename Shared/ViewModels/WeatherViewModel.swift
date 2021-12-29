//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var currentLocation: Location?
    @Published var fetchedLocations: [Location] = []
    
    @Published var weathers: [Weather] = []
    @Published private(set) var viewStatus = ViewStatus.idle
    
    let searchSuggestions: [String] = [
        "Auckland", "Barcelona", "London", "New York", "San Francisco", "Paris", "Rio de Janeiro"
    ]
    let initialLocation = "San Francisco"
    
    func fetchLocations(by params: LocationParams) async {
        updateViewStatus(newStatus: .fetchingLocations)
        do {
            var locations: [Location] = []
            defer {
                updateLocations(locations)
            }
            switch params {
            case .query(let queryString):
                locations = try await LocationService.fetchLocation(byText: queryString)
            case .coordinate(let latitude, let longitude):
                locations = try await LocationService.fetchLocation(byLatitude: latitude, andLongitude: longitude)
            }
        } catch {
            updateViewStatus(newStatus: .error(message: "Error on fetching location: \(error.localizedDescription)"))
        }
    }
    
    func fetchWeather(for location: Location) async {
        selectLocation(location)
        updateViewStatus(newStatus: .fetchingWeather)
        do {
            let weathers = try await WeatherService.fetchWeather(location: location)
            updateWeathers(weathers)
            updateViewStatus(newStatus: .weathersLoaded(weathers, location: location))
        } catch {
            updateViewStatus(newStatus: .error(message: "Error on fetching location: \(error.localizedDescription)"))
        }
    }
    
    func fetchLocationThenWeather(by query: String) async {
        updateViewStatus(newStatus: .fetchingLocations)
        do {
            let locations = try await LocationService.fetchLocation(byText: query)
            guard let firstLocation = locations.first else {
                updateViewStatus(newStatus: .empty)
                return
            }
            await fetchWeather(for: firstLocation)
        } catch {
            updateViewStatus(newStatus: .error(message: "Error on fetching location: \(error.localizedDescription)"))
        }
    }
    
    func selectLocation(_ location: Location) {
        DispatchQueue.main.async { [weak self] in
            self?.currentLocation = location
        }
    }
    
    func updateViewStatus(newStatus: ViewStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.viewStatus = newStatus
        }
    }
    
    func updateWeathers(_ weathers: [Weather]) {
        DispatchQueue.main.async {
            self.weathers = weathers
        }
    }
    
    func updateLocations(_ locations: [Location]) {
        DispatchQueue.main.async { [weak self] in
            self?.fetchedLocations = locations
            self?.updateViewStatus(newStatus: locations.count > 0 ? .locationsLoaded(locations) : .empty)
        }
    }

}
