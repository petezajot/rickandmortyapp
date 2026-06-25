//
//  SpaceBackground.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import SwiftUI

struct SpaceBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [
                        .black,
                        Color(red: 0.02, green: 0.02, blue: 0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ForEach(0..<300, id: \.self) { _ in
                    Circle()
                        .fill(.white)
                        .frame(width: 2, height: 2)
                        .position(
                            x: CGFloat.random(in: 0...proxy.size.width),
                            y: CGFloat.random(in: 0...proxy.size.height)
                        )
                }
            }
        }
    }
}

#Preview {
    SpaceBackground()
}
