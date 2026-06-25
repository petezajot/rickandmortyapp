//
//  ListItems.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 10/06/26.
//

import SwiftUI

struct ListItems: View {
    var items: StickerEntity
    
    var body: some View {
        if items.id % 2 == 0 {
            HStack {
                VStack (alignment: .leading){
                    Text("#\(items.id)")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    
                    Text(items.name ?? "")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Species: \(items.species ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Status: \(items.status ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Type: \(items.type ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Gender: \(items.gender ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                }
                .padding(5)
                .lineSpacing(15)
                Spacer()
                AsyncImage(url: URL(string: items.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(12)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipped()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                 .stroke(.green, lineWidth: 2)
            }
            .cornerRadius(12)
        } else {
            HStack {
                AsyncImage(url: URL(string: items.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(12)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipped()
                Spacer()
                VStack (alignment: .leading){
                    Text("#\(items.id)")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    
                    Text(items.name ?? "")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Species: \(items.species ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Status: \(items.status ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Type: \(items.type ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Gender: \(items.gender ?? "")")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                }
                .padding(5)
                .lineSpacing(15)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.green, lineWidth: 2)
            }
            .cornerRadius(12)
        }
    }
}
