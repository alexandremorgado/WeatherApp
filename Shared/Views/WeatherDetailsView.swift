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
    
    @State private var selectedWeatherIndex: Int = 0
    @State private var tempInFahrenheit = true
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(alignment: .center, spacing: 20) {
                Text(location.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding()
                TabView(selection: $selectedWeatherIndex) {
                    ForEach(weathers) { weather in
                        weatherContentView(weather)
                    }
                }
                #if os(macOS)
                .tabViewStyle(.automatic)
                #elseif os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .always))
                #endif
                .layoutPriority(10)
                
                if let coordinate = location.coordinate {
                    mapView(coordinate: coordinate)
                        .layoutPriority(5)
                    Spacer()
                }
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            selectedWeatherIndex = 0
        }
    }
    
    func weatherContentView(_ weather: Weather) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(weather.applicableDate.formatted(date: .long, time: .omitted))
                .font(.title3)
            
            HStack(alignment: .top) {
                Text(tempInFahrenheit ? weather.fahrenheitTempFormatted : weather.celsiusTempFormatted)
                    .font(.system(size: 64))
                Text(tempInFahrenheit ? "℉" : "℃")
                    .padding(.top, 10)
            }
            .padding(.leading)
            .onTapGesture {
                withAnimation { tempInFahrenheit.toggle() }
            }
            
            stateView(weather)
            pressureAndHumidityView(weather)
        }
        .tabItem {
            Text("\((weathers.firstIndex(of: weather) ?? 0) + 1)")
        }
    }
    
    func stateView(_ weather: Weather) -> some View {
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
    
    func pressureAndHumidityView(_ weather: Weather) -> some View {
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
        .padding()
        .padding(.bottom, 40)
    }
    
    func mapView(coordinate: CLLocationCoordinate2D) -> some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: coordinate, latitudinalMeters: 8000, longitudinalMeters: 500)))
            .frame(minHeight: 188, maxHeight: .infinity)
            .cornerRadius(10)
            .padding(.horizontal)
    }
    
}

struct WeatherDetailsView_Previews: PreviewProvider {
    
    static let devices: [String] = ["iPhone SE (2nd generation)", "iPhone 13 Pro Max", "iPad Air (4th generation)"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            WeatherDetailsView(
                weathers: [Weather.sample],
                location: Location.sample
            )
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
