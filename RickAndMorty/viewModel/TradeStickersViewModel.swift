//
//  TradeStickersViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation
import CoreData
import Combine

protocol TradeStickersProtocol: ObservableObject {
    var duplicatedStickers: [StickerEntity] { get set }
    
    func fetchDuplicatedStickers()
}

@MainActor
final class TradeStickersViewModel: TradeStickersProtocol {
    @Published var duplicatedStickers: [StickerEntity] = []
    
    private let stickerRepository: StickerRepositoryProtocol
    
    init(stickerRepository: StickerRepositoryProtocol) {
        self.stickerRepository = stickerRepository
    }
    
    func fetchDuplicatedStickers() {
        let allStickers = stickerRepository.fetchAllStickers()
        
        duplicatedStickers = allStickers.filter { sticker in
            sticker.quantity > 1
        }
    }
}
