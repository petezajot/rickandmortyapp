//
//  TradeStickerPayloadCard.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 17/06/26.
//

import SwiftUI

struct TradeStickerPayloadCard: View {
    let sticker: TradeStickerPayload
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: sticker.image ?? "")) { phase in
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
            
            Text("sticker.name")
                .font(.orbitronBold(withSize: 14))
                .foregroundColor(.green)
                .lineLimit(1)
            
            Text("#\(sticker.id)")
                .font(.orbitronRegular(withSize: 12))
                .foregroundColor(.green.opacity(0.8))
            
            Text(sticker.species)
                .font(.orbitronRegular(withSize: 11))
                .foregroundColor(.green.opacity(0.8))
                .lineLimit(1)
        }
        .padding(10)
        .background(.black.opacity(0.8))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green, lineWidth: 2)
        }
        .cornerRadius(12)
    }
}
