//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 03/06/26.
//

import Foundation

enum Endpoint {
    case characters(page: Int)
    case character(id: Int)
    case locations(page: Int)
    case multipleCharacters(ids: String)
    
    var path: String {
        switch self {
        case .characters(let page):
            return "/character/?page=\(page)"
        case .character(let id):
            return "/character/\(id)"
        case .locations(page: let page):
            return "/location?page=\(page)"
        case .multipleCharacters(let ids):
            return "/character/\(ids)"
        }
    }
}
