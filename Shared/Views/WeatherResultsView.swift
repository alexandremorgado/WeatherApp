//
//  WeatherResultsView.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 29/12/21.
//

import SwiftUI

struct WeatherResultsView: View {
    
    let viewStatus: ViewStatus
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    
    var onSelectLocation: ((Location) -> Void)?
    var onCancelSearch: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .center) {
            switch viewStatus {
            case .fetchingLocations:
                ProgressView("Fetching location...")
            case .fetchingWeather:
                ProgressView("Fetching weather...")
            case .fetchingCurrentLocation:
                ProgressView("Fetching current location...")
            case .locationsLoaded(let locations):
                locationsList(locations)
            case .weathersLoaded(let weathers, let location):
                WeatherDetailsView(weathers: weathers, location: location)
                    .onAppear {
                        dismissSearch()
                    }
            case .empty:
                Text("No whispers loaded")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let errorMessage):
                Text(errorMessage)
                    .padding()
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        dismissSearch()
                    }
            case .idle:
                Text("Select a location")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .onChange(of: isSearching) { isSearching in
            if !isSearching {
                onCancelSearch?()
            }
        }
    }
    
    func locationsList(_ locations: [Location]) -> some View {
        List(locations) { location in
            Text(location.title)
                .padding(.vertical, 5)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelectLocation?(location)
                }
        }
        .listStyle(.insetGrouped)
    }
    
}

struct WeatherResultView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherResultsView(viewStatus: .idle)
    }
}
