//
//  TradeSearchingView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI
import CoreData

struct TradeSearchingView: View {
    let sticker: StickerEntity
    
    @StateObject private var viewModel: TradeSearchingViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var repeatedCount: Int64 {
        max(sticker.quantity - 1, 0)
    }
    
    private let counterOfferColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    init(
        sticker: StickerEntity,
        viewModel: TradeSearchingViewModel
    ) {
        self.sticker = sticker
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            SpaceBackground()
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.stopSearching()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                .padding(.horizontal)
                
                Text("Searching Trade")
                    .font(.orbitronBold(withSize: 20))
                    .foregroundColor(.green)
                    .shadow(color: .green, radius: 6)
                
                AsyncImage(url: URL(string: sticker.image ?? "")){ phase in
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
                
                Text(sticker.name ?? "Unknown")
                    .font(.orbitronBold(withSize: 18))
                    .foregroundColor(.green)
                
                Text("#\(sticker.id)")
                    .font(.orbitronRegular(withSize: 12))
                    .foregroundColor(.green.opacity(0.8))
                
                Text("Available for trade \(repeatedCount)")
                    .font(.orbitronRegular(withSize: 14))
                    .foregroundColor(.green.opacity(0.8))
                
                if viewModel.isSearching {
                    ProgressView()
                        .tint(.green)
                    
                    Text("Searching for nearby players...")
                        .font(.orbitronRegular(withSize: 14))
                        .foregroundColor(.green)
                }
                
                if viewModel.foundPeers.isEmpty {
                    Text("No players found yet.")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green.opacity(0.7))
                } else {
                    VStack(spacing: 8) {
                        Text("Nearby players")
                            .font(.orbitronBold(withSize: 14))
                            .foregroundColor(.green)
                        
                        ForEach(viewModel.foundPeers) { peer in
                            Button {
                                viewModel.sendOffer(
                                    sticker: sticker,
                                    to: peer
                                )
                            } label: {
                                Text("Send offer to \(peer.name)")
                                    .font(.orbitronRegular(withSize: 14))
                                    .foregroundColor(.green)
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.green, lineWidth: 1)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let responseMessage = viewModel.responseMessage {
                    Text(responseMessage)
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
            }
            .padding()
            
            if let incomingOffer = viewModel.incomingOffer,
               let incomingOfferPeer = viewModel.incomingOfferPeer {
                VStack(spacing: 12) {
                    Text("Trade Offer")
                        .font(.orbitronBold(withSize: 18))
                        .foregroundColor(.green)
                    
                    Text("\(incomingOfferPeer.name) wants to trade:")
                        .font(.orbitronBold(withSize: 12))
                        .foregroundColor(.green.opacity(0.8))
                    
                    Text(incomingOffer.sticker.name)
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                    
                    Text("#\(incomingOffer.sticker.id)")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green)
                    
                    HStack(spacing: 16) {
                        Button{
                            viewModel.rejectIncomingOffer()
                        } label: {
                            Text("Reject")
                                .font(.orbitronBold(withSize: 14))
                                .foregroundColor(.red)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.green, lineWidth: 2)
                                }
                        }
                        
                        Button{
                            viewModel.showCounterOfferSelection()
                        } label: {
                            Text("Choose offer")
                                .font(.orbitronBold(withSize: 14))
                                .foregroundColor(.green)
                                .padding()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.green, lineWidth: 2)
                                }
                        }
                    }
                    
                    if viewModel.showCounterOfferOptions {
                        Text("Choose one repeated sticker to offer:")
                            .font(.orbitronRegular(withSize: 12))
                            .foregroundColor(.green.opacity(0.8))
                        
                        ScrollView {
                            LazyVGrid(columns: counterOfferColumns, spacing: 12) {
                                ForEach(viewModel.duplicatedStickersForCounterOffer, id: \.objectID) { duplicatedSticker in
                                    DuplicateStickerGridItem(sticker: duplicatedSticker)
                                        .onTapGesture {
                                            viewModel.sendCounterOffer(with: duplicatedSticker)
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxHeight: 260)
                    }
                }
                .padding()
                .background(.black.opacity(0.9))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.green, lineWidth: 2)
                }
                .cornerRadius(16)
                .padding()
                .zIndex(10)
            }
            
            if let counterOffer = viewModel.incomingCounterOffer,
               let counterOfferPeer = viewModel.incomingCounterOfferPeer {
                VStack (spacing: 12) {
                    Text("Counter offer")
                        .font(.orbitronBold(withSize: 18))
                        .foregroundColor(.green)
                    
                    Text("\(counterOfferPeer.name) offers:")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green.opacity(0.8))
                    
                    TradeStickerPayloadCard(sticker: counterOffer.counterSticker)
                    
                    Text("For you:")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green.opacity(0.8))
                    
                    TradeStickerPayloadCard(sticker: counterOffer.originalSticker)
                    
                    Button {
                        viewModel.clearIncomingCounterOffer()
                    } label: {
                        Text("Ok")
                            .font(.orbitronBold(withSize: 14))
                            .foregroundColor(.green)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.green, lineWidth: 2)
                            }
                    }
                }
                .padding()
                .background(.black.opacity(0.8))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.green, lineWidth: 12)
                }
                .cornerRadius(12)
                .padding()
                .zIndex(11)
            }
        }
        .onAppear {
            viewModel.startSearching()
        }
        .onDisappear {
            viewModel.stopSearching()
        }
    }
}
