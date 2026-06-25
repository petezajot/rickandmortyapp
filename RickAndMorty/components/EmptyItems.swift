//
//  EmptyItems.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 10/06/26.
//

import SwiftUI

struct EmptyItems: View {
    var slot: Int
    
    var body: some View {
        if slot % 2 == 0 {
            HStack {
                VStack (alignment: .leading){
                    Text("#\(slot)")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    
                    Text("Name: -")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Species: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Status: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Type: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Gender: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                }
                .padding(5)
                .lineSpacing(15)
                Spacer()
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.green, lineWidth: 2)
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 5)
                    .frame(width: 100, height: 100)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                 .stroke(.green, lineWidth: 2)
                 .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 5)
            }
            .cornerRadius(12)
        } else {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.green, lineWidth: 2)
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 5)
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                VStack (alignment: .leading){
                    Text("#\(slot)")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    
                    Text("Name: -")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Species: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Status: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Type: -")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                        .shadow(color: .green, radius: 6)
                    Text("Gender: -")
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
                    .shadow(color: .green.opacity(0.3), radius: 12, x: 0, y: 5)
            }
            .cornerRadius(12)
        }
    }
}
