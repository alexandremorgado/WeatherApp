//
//  ViewModifiers.swift
//  WeatherApp
//
//  Created by Alexandre Morgado on 29/12/21.
//

import SwiftUI

struct BoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                ContainerRelativeShape()
                    .fill(Color.gray.opacity(0.35))
                    .cornerRadius(10)
            )
    }
}

extension View {
    func boxShape() -> some View {
        self.modifier(BoxModifier())
    }
}
