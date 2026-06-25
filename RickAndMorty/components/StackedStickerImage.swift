//
//  StackedStickerImage.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct StackedStickerImage: View {
    let imageURL: String?
    let quantity: Int64
    
    private var hasDuplicates: Bool {
        quantity > 1
    }
    
    var body: some View {
        ZStack {
            if hasDuplicates {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.green.opacity(0.25), lineWidth: 2)
                    .background(.black.opacity(0.4))
                    .cornerRadius(16)
                    .offset(x: 22, y: 22)
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.green.opacity(0.45), lineWidth: 2)
                    .background(.black.opacity(0.4))
                    .cornerRadius(16)
                    .offset(x: 7, y: 7)
            }
            
            AsyncImage(url: URL(string: imageURL ?? "")) { phase in
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
            .frame(width: 180, height: 180)
            .clipped()
            .cornerRadius(16)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.green, lineWidth: 2)
            }
        }
        .frame(width: 200, height: 200)
    }
}
