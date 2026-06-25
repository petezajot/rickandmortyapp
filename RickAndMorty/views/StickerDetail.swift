//
//  StickerDetail.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct StickerDetail: View {
    let sticker: StickerEntity
    
    private var duplicates: Int64 {
        max(sticker.quantity - 1, 0)
    }
    
    var body: some View {
        ZStack {
            SpaceBackground()
            
            VStack(spacing: 16) {
                HStack {
                    Text("#\(sticker.id)")
                        .font(.orbitronBold(withSize: 24))
                    Text(sticker.name ?? "Unknown")
                        .font(.orbitronBold(withSize: 24))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 15)
                
                
                StackedStickerImage(
                    imageURL: sticker.image,
                    quantity: sticker.quantity
                )
                
                Text("Status: \(sticker.status ?? "-")")
                    .font(.orbitronRegular(withSize: 16))
                Text("Species: \(sticker.species ?? "-")")
                    .font(.orbitronRegular(withSize: 16))
                Text("Gender: \(sticker.gender ?? "-")")
                    .font(.orbitronRegular(withSize: 16))
                if duplicates > 1 {
                    Text("Repeated: \(duplicates)")
                        .font(.orbitronRegular(withSize: 16))
                }
            }
            .foregroundColor(.green)
            .padding()
        }
    }
}
