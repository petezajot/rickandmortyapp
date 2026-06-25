//
//  PackResultView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI

struct PackResultView: View {
    @Environment(\.dismiss) private var dismiss
    let stickers: [Character]
    
    @State private var envelopeOpened = false
    @State private var showCards = false
    
    var body: some View {
        ZStack {
            SpaceBackground()
            
            VStack(spacing: 24) {               
                Text("New Stickers")
                    .font(.orbitronBold(withSize: 18))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 6)
                
                Image("card")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
                    .rotation3DEffect(
                        .degrees(envelopeOpened ? -75 : 0),
                        axis: (x: 1, y: 0, z: 0),
                        anchor: .top
                    )
                    .opacity(showCards ? 0 : 1)
                
                if showCards {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(stickers, id: \.id) { sticker in
                                StickerRevealCard(sticker: sticker)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                if showCards {
                    Button {
                        dismiss()
                    } label: {
                        Text("Guardar y continuar")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.green, lineWidth: 2)
                            }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                envelopeOpened = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                    showCards = true
                }
            }
        }
    }
}
