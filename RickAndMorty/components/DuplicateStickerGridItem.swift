//
//  DuplicateStickerGridItem.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct DuplicateStickerGridItem: View {
    let sticker: StickerEntity
    
    private var repeatedCount: Int64 {
        max(sticker.quantity - 1, 0)
    }
    
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
            .frame(width: 110, height: 110)
            .clipped()
            .cornerRadius(12)
            
            Text(sticker.name ?? "Unknown")
                .font(.orbitronBold(withSize: 12))
                .foregroundColor(.green)
                .lineLimit(1)
            
            Text("Repeated \(repeatedCount)")
                .font(.orbitronRegular(withSize: 10))
                .foregroundColor(.green.opacity(0.75))
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.75))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.green, lineWidth: 2)
        }
        .cornerRadius(12)
        .shadow(color: .green.opacity(0.35), radius: 6)
    }
}
