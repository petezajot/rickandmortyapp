//
//  ListsView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import SwiftUI
import Combine

struct ListsView: View {
    let coordinator: AppCoordinator
    @StateObject private var charactersViewModel: CharactersViewModel
    
    @State private var stickers: [StickerEntity] = []
    
    @State private var currentPage = 1
    @State private var albumTotalCount = 0
    private let itemsPerPage: Int = 20
    
    private var totalPages: Int {
        guard albumTotalCount > 0 else { return 0 }
        return Int(ceil(Double(albumTotalCount) / Double(itemsPerPage)))
    }
    
    private var currentSlots: [Int] {
        guard albumTotalCount > 0 else { return [] }
        let start = ((currentPage - 1) * itemsPerPage) + 1
        let end = min(currentPage * itemsPerPage, albumTotalCount)
        
        guard start <= end else { return [] }
        return Array(start...end)
    }
    
    private var stickersById: [Int64: StickerEntity] {
        Dictionary(
            uniqueKeysWithValues: stickers.map { ($0.id, $0) }
        )
    }
    
    init(
        coordinator: AppCoordinator,
        charactersViewModel: CharactersViewModel
    ) {
        self.coordinator = coordinator
        _charactersViewModel = StateObject(wrappedValue: charactersViewModel)
    }
    
    var body: some View {
        ZStack {
            SpaceBackground()
            ScrollViewReader { proxy in
                List {
                    ForEach(currentSlots, id: \.self) { slotId in
                        if let sticker = stickersById[Int64(slotId)] {
                            ListItems(items: sticker)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    coordinator.goToStickerDetail(sticker: sticker)
                                }
                        } else {
                            EmptyItems(slot: slotId)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .onChange(of: currentPage) { _, _ in
                    DispatchQueue.main.async {
                        if let first = currentSlots.first {
                            withAnimation {
                                proxy.scrollTo(first, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    guard currentPage > 1 else { return }
                    currentPage -= 1
                } label: {
                    Text("Previous")
                        .font(.orbitronRegular(withSize: 10))
                        .foregroundColor(currentPage <= 1 ? .gray : .green)
                        .shadow(color: .green, radius: 6)
                }
                .disabled(currentPage <= 1)
            }
            ToolbarItem(placement: .principal) {
                Text("Page \(currentPage)/\(totalPages)")
                    .font(.orbitronBold(withSize: 14))
                    .foregroundColor(.green)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    guard currentPage < totalPages else { return }
                    currentPage += 1
                } label: {
                    Text("Next")
                        .font(.orbitronRegular(withSize: 10))
                        .foregroundColor(currentPage >= totalPages ? .gray : .green)
                        .shadow(color: .green, radius: 6)
                }
                .disabled(currentPage >= totalPages)
            }
        }
        .task {
            let length: Int = UserDefaultsManager.shared.getInt(forKey: .albumLength)
            guard length > 0 else { return }
            albumTotalCount = length
            
            stickers = charactersViewModel.fetchAllStickers()
        }
        .overlay {
            if charactersViewModel.isLoading {
                Loader()
            }
        }
    }
}
