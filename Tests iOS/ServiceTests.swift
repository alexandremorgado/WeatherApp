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
            XCTFail("Expected chopped vegetables, but failed \(error).")
        }
        
    }
    
}

extension Date {
    func isSameDay(of date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: self, to: date)
        return diff.day == 0
    }
}
