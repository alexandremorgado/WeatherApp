//
//  WeatherView.swift
//  Shared
//
//  Created by Alexandre Morgado on 28/12/21.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Text("Location weather")
                    .padding()
            }
            .navigationTitle("Location")
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
