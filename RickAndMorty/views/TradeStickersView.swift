//
//  TradeStickersView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import SwiftUI
import CoreData

struct TradeStickersView: View {
    let coordinator: AppCoordinator
    @StateObject private var viewModel: TradeStickersViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    init(
        coordinator: AppCoordinator,
        viewModel: TradeStickersViewModel
    ) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            SpaceBackground()
            
            if viewModel.duplicatedStickers.isEmpty {
                VStack(spacing: 12) {
                    Text("No repeated stickers")
                        .font(.orbitronBold(withSize: 16))
                        .foregroundColor(.green)
                    
                    Text("You need repeated stickers to trade")
                        .font(.orbitronRegular(withSize: 12))
                        .foregroundColor(.green.opacity(0.8))
                }
                .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.duplicatedStickers, id: \.objectID) { sticker in
                            DuplicateStickerGridItem(sticker: sticker)
                                .onTapGesture {
                                    coordinator.goToTradeSearching(sticker: sticker)
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Trade Stickers")
                    .font(.orbitronBold(withSize: 14))
                    .foregroundColor(.green)
            }
        }
        .task {
            viewModel.fetchDuplicatedStickers()
        }
    }
}
