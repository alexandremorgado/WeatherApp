//
//  ServiceTests.swift
//  Tests iOS
//
//  Created by Alexandre Morgado on 28/12/21.
//

import XCTest

// Test MetaWeather API
class ServicesTests: XCTestCase {
    
    let london = Location(woeid: 44418, title: "London")
    
    func testLocations() async throws {
        // by query
        let fetchedLondon = try await LocationService.fetchLocation(byText: "london").first
        XCTAssertEqual(fetchedLondon?.woeid, london.woeid)
        
        // by coordinate
        let locations = try await LocationService.fetchLocation(byLatitude: 37.77, andLongitude: -122.41)
        let sanFrancisco = locations.first
        XCTAssertEqual(sanFrancisco?.woeid, 2487956)
    }

    func testWeather() async throws {
        do {
            let locationWeather = try await WeatherService.fetchWeather(location: london)
            XCTAssertGreaterThan(locationWeather.count, 0)
            XCTAssert(locationWeather[0].applicableDate.isSameDay(of: Date()))
        } catch {
            XCTFail("Expected fetch weather for location, but failed \(error)")
        }
    }
    
    func testIntegration() async throws {
        do {
            let rioSearch = try await LocationService.fetchLocation(byText: "rio")
            XCTAssertGreaterThan(rioSearch.count, 0)
            let rioWeather = try await WeatherService.fetchWeather(location: rioSearch[0])
            XCTAssertGreaterThan(rioWeather.count, 0)
        } catch {
            XCTFail("Could not fetch this location")
        }
    }
    
}

extension Date {
    func isSameDay(of date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: date)
        return diff.day == 0
    }
}
