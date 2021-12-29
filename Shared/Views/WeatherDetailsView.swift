//
//  WeatherDetailsView.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 28/12/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct WeatherDetailsView: View {
    
    let weathers: [Weather]
    let location: Location
    
    @State private var currentWeather: Weather?
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                if let weather = currentWeather {
                    VStack(alignment: .center, spacing: 10) {
                        Text(location.title)
                            .font(.title)
                            .fontWeight(.light)
                        
                        HStack(alignment: .top) {
                            Text("\(weather.fahrenheitTempFormatted)")
                                .font(.system(size: 58))
                            Text("℉")
                                .padding(.top, 10)
                        }
                        .padding(.leading)
                        
                        stateView(weather: weather)
                        
                        pressureAndHumidityView(weather: weather)
                        
                        if let coordinate = location.coordinate {
                            mapView(coordinate: coordinate)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .colorScheme(.dark)
        .onAppear {
            currentWeather = weathers.first
        }
    }
    
    func stateView(weather: Weather) -> some View {
        HStack {
            AsyncImage(
                url: weather.iconURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                },
                placeholder: {
                    ProgressView()
                        .frame(height: 20)
                }
            )
            Text(weather.weatherStateName)
                .font(.title3)
        }
    }
    
    func pressureAndHumidityView(weather: Weather) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Pressure")
                    .font(.subheadline)
                Text("\(weather.airPressureFormatted)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .boxShape()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Humidity")
                    .font(.subheadline)
                Text("\(weather.humidityFormatted)")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .boxShape()
        }
        .padding([.horizontal, .top])
    }
    
    func mapView(coordinate: CLLocationCoordinate2D) -> some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, latitudinalMeters: 8000, longitudinalMeters: 500)))
            .frame(height: 280)
            .cornerRadius(10)
            .padding()
    }
    
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView(
            weathers: [Weather.sample],
            location: Location.sample
        )
    }
}
