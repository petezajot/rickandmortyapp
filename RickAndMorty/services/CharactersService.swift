//
//  CharactersService.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import Foundation

protocol CharactersServiceProtocol {
    func fetchCharacters(for page: Int) async throws -> CharactersModel
    func fetchSingleCharacter(withId id: Int) async throws -> Character
    func fetchMultipleCharacters(withIds ids: String) async throws -> [Character]
}

final class CharactersService: CharactersServiceProtocol {
    private let apiManager: APIManager
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchCharacters(for page: Int) async throws -> CharactersModel {
        try await apiManager.request(
            .characters(page: page),
            method: .get,
            responseType: CharactersModel.self
        )
    }
    
    func fetchSingleCharacter(withId id: Int) async throws -> Character {
        try await apiManager.request(
            .character(id: id),
            method: .get,
            responseType: Character.self
        )
    }
    
    func fetchMultipleCharacters(withIds ids: String) async throws -> [Character] {
        try await apiManager.request(
            .multipleCharacters(ids: ids),
            method: .get,
            responseType: [Character].self
        )
    }
    
}
