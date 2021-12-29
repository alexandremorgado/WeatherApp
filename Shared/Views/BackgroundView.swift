//
//  BackgroundView.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 29/12/21.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        let colorScheme = [Color.black,
                           Color(red: 10/255, green: 61/255, blue: 180/255),
                           Color(red: 41/255, green: 87/255, blue: 161/255)]
        
        let gradient = Gradient(colors: colorScheme)
        let linearGradient = LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom)
        
        let background = Rectangle()
            .fill(linearGradient)
            .blur(radius: 200, opaque: true)
            .edgesIgnoringSafeArea(.all)
        
        return background
    }
}
