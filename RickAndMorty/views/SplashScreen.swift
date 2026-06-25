//
//  SplashScreen.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import SwiftUI

struct SplashScreen: View {
    let onFinish: () -> Void
    
    @State private var  rotatePortal = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SpaceBackground()
                ZStack (alignment: .center) {
                    Image("greenportal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .rotationEffect(.degrees(rotatePortal ? 360 : 0))
                        .shadow(color: .green, radius: 10)
                        .animation(
                            .linear(duration: 10)
                            .repeatForever(autoreverses: false), value: rotatePortal
                        )
                        .task {
                            rotatePortal = true
                            try? await Task.sleep(nanoseconds: 5_000_000_000)
                            
                            withAnimation {
                                onFinish()
                            }
                        }
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width, height: 130)
                        .padding()
                    
                    Text("ALBUM")
                        .font(.orbitronBold(withSize: 18))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 8)
                        .padding(.top, 265)
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
}
