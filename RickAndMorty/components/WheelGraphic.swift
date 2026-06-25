//
//  WheelGraphic.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct WheelGraphic: View {
    let prizes: [DailyRewardPrize]
    let rotation: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.black.opacity(0.85))
            
            Circle()
                .stroke(.green, lineWidth: 3)
                .shadow(color: .green, radius: 8)
            
            ForEach(prizes) { prize in
                Text(prize.title)
                    .font(.orbitronBold(withSize: 16))
                    .foregroundColor(.green)
                    .offset(y: -105)
                    .rotationEffect(.degrees(Double(prize.id) * 36))
            }
        }
        .rotationEffect(.degrees(rotation))
    }
}
