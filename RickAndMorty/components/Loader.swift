//
//  Loader.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import SwiftUI

struct Loader: View {
    @State private var  rotatePortal = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack (alignment: .center) {
                Image("greenportal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(rotatePortal ? 360 : 0))
                    .shadow(color: .green, radius: 10)
                    .animation(
                        .linear(duration: 10)
                        .repeatForever(autoreverses: false), value: rotatePortal
                    )
                    .task {
                        rotatePortal = true
                    }
                
                Text("Please wait...")
                    .font(.orbitronBold(withSize: 16))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 6)
            }
            .ignoresSafeArea()
            .frame(
                width: proxy.size.width,
                height: proxy.size.height,
                alignment: .center
            )
            .background(.black.opacity(0.8))
            .padding()
            
        }
    }
}

#Preview {
    Loader()
}
