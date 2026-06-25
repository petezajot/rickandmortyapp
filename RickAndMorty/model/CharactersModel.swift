//
//  CharactersModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 03/06/26.
//

import Foundation

struct CharactersModel: Codable {
    let info: Info
    let results: [Character]
    
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Origin: Codable, Equatable {
    let name: String
    let url: String
}

struct Location: Codable, Equatable {
    let name: String
    let url: String
}
