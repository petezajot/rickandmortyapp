//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 03/06/26.
//

import Foundation
import Combine
import CoreData

protocol CharactersViewModelProtocol {
    var charactersList: CharactersModel? { get set }
    var character: Character? { get set }
    var characters: [Character]? { get set }
    var lastPackStickers: [Character] { get set }
    var showPackResult: Bool { get set }
    var pointsError: Bool { get set }
    
    var error: Error? { get set }
    var isLoading: Bool { get set }
    
    func fetchCharacters(for page: Int) async
    
    func fetchSingleCharacter(withId id: Int) async
    
    func fetchMultipleCharacters(withIds ids: String) async
    
    func saveStickers(from characters: [Character])
    
    func fetchAllStickers() -> [StickerEntity]
    
    func buyPack(quantity cards: Int, cost: Int) async
}

@MainActor
final class CharactersViewModel: CharactersViewModelProtocol, ObservableObject {
    @Published var charactersList: CharactersModel?
    @Published var character: Character?
    @Published var characters: [Character]?
    @Published var lastPackStickers: [Character] = []
    @Published var showPackResult: Bool = false
    @Published var pointsError: Bool = false
    @Published var error: (any Error)?
    @Published var isLoading: Bool = false
    
    let service: CharactersServiceProtocol
    let stickerRepository: StickerRepositoryProtocol
    let pointsManager: PointsManagerProtocol
    init(
        service: CharactersServiceProtocol,
        stickerRepository: StickerRepositoryProtocol,
        pointsManager: PointsManagerProtocol
    ) {
        self.service = service
        self.stickerRepository = stickerRepository
        self.pointsManager = pointsManager
    }
    
    func fetchCharacters(for page: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.fetchCharacters(for: page)
            charactersList = data
        } catch {
            self.error = error
        }
    }
    
    func fetchSingleCharacter(withId id: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.fetchSingleCharacter(withId: id)
            character = data
        } catch {
            self.error = error
        }
    }
    
    func fetchMultipleCharacters(withIds ids: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.fetchMultipleCharacters(withIds: ids)
            characters = data
        } catch {
            self.error = error
        }
    }
    
    func saveStickers(from characters: [Character]) {
        isLoading = true
        defer { isLoading = false }
        stickerRepository.saveStickers(from: characters)
    }
    
    func fetchAllStickers() -> [StickerEntity] {
        isLoading = true
        defer { isLoading = false }
        return stickerRepository.fetchAllStickers()
    }
    
    func buyPack(quantity cards: Int, cost: Int) async {
        isLoading = true
        pointsError = false
        
        defer { isLoading = false }
        
        let didPay = pointsManager.spendPoints(cost)
        guard didPay else {
            print("Not enough points")
            pointsError = true
            return
        }
        
        let length = UserDefaultsManager.shared.getInt(forKey: .albumLength)
        guard length > 0 else { return }
        
        let ids = StickerGenerator.generatePack(
            quantity: cards,
            albumLength: length
        )
        
        do {
            let data = try await service.fetchMultipleCharacters(withIds: ids)
            characters = data
            stickerRepository.saveStickers(from: data)
            lastPackStickers = data
            showPackResult = true
        } catch {
            self.error = error
        }
    }
}
