//
//  StickerRevealCard.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct StickerRevealCard: View {
    let sticker: Character
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: sticker.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "xmark.octagon")
                        .foregroundColor(.red)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 120)
            .clipped()
            .cornerRadius(12)
            
            Text(sticker.name)
                .font(.orbitronBold(withSize: 12))
                .foregroundColor(.green)
                .lineLimit(1)
            
            Text("#\(sticker.id)")
                .font(.orbitronRegular(withSize: 10))
                .foregroundColor(.green.opacity(0.8))
        }
        .frame(width: 150, height: 210)
        .padding(8)
        .background(.black.opacity(0.75))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green, lineWidth: 2)
        }
        .cornerRadius(12)
    }
}
