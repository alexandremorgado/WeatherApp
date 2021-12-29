//
//  WeatherMainView.swift
//  Shared
//
//  Created by Alexandre Morgado on 28/12/21.
//

import SwiftUI
#if !os(macOS)
import CoreLocationUI
#endif

struct WeatherMainView: View {
    
    @StateObject var viewModel = WeatherViewModel()
    @StateObject var locationManager = LocationManager()
    
    @State private var searchQuery: String = ""
    
    var searchPlacement: SearchFieldPlacement {
        #if os(iOS)
        SearchFieldPlacement.navigationBarDrawer(displayMode: .always)
        #else
        SearchFieldPlacement.automatic
        #endif
    }
    
    var filteredSuggestions: [String] {
        viewModel.searchSuggestions.filter {
            $0.lowercased().hasPrefix(searchQuery.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                WeatherResultsView(
                    viewStatus: viewModel.viewStatus,
                    onSelectLocation: { location in
                        searchQuery = location.title
                        Task { await viewModel.fetchWeather(for: location) }
                    },
                    onCancelSearch: {
                        guard let location = viewModel.currentLocation else { return }
                        Task { await viewModel.fetchWeather(for: location) }
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("WeatherApp")
            #if os(macOS)
            .navigationViewStyle(.automatic)
            .frame(minWidth: 400)
            #else
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .searchable(
                text: $searchQuery,
                placement: searchPlacement, 
                prompt: "Search location"
            ) {
                switch viewModel.viewStatus {
                case .idle, .weathersLoaded, .empty, .error:
                    suggestionsView
                default:
                    EmptyView()
                }
            }
        }
        #if !os(macOS)
        .navigationViewStyle(.stack)
        #endif
        .preferredColorScheme(.dark)
        .task {
            await viewModel.fetchLocationThenWeather(by: viewModel.initialLocation)
        }
        .onSubmit(of: .search) {
            Task { await viewModel.fetchLocations(by: .query(searchQuery)) }
        }
        .onReceive(locationManager.$location) { location in
            guard let lat = location?.latitude, let long = location?.longitude else { return }
            Task {
                await viewModel.fetchLocations(by: .coordinate(latitude: lat, longitude: long))
            }
        }
        .onReceive(locationManager.$errorOnFetchingLocation) { error in
            guard error != nil else { return }
            viewModel.updateViewStatus(newStatus: .error(message: "Could not fetch current location"))
        }
    }
    
    var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 14) {
            if searchQuery.count == 0 {
                Text("Suggestions")
                    .font(.title3)
                    .fontWeight(.bold)
                ForEach(filteredSuggestions, id: \.self) { text in
                    Text(text)
                        .contentShape(Rectangle())
                        .searchCompletion(text)
                        .onTapGesture {
                            searchQuery = text
                            Task { await viewModel.fetchLocationThenWeather(by: text) }
                        }
                }
                Spacer()
                    .frame(height: 10)
                #if !os(macOS)
                Text("Locations")
                    .font(.title3)
                    .fontWeight(.bold)
                currentLocationButton
                #endif
            } else {
                Text("Insert a location and enter to search")
            }
            Spacer()
        }
        
    }
    
    #if !os(macOS)
    var currentLocationButton: some View  {
        LocationButton {
            viewModel.updateViewStatus(newStatus: .fetchingCurrentLocation)
            locationManager.requestLocation()
        }
        .cornerRadius(10)
    }
    #endif
    
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}
