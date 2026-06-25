//
//  LocationsModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 04/06/26.
//

import Foundation

struct LocationsModel: Decodable {
    let info: Info
    let results: [Results]
}

struct Results: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
