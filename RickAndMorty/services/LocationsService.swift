//
//  LocationsService.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 05/06/26.
//

import Foundation

protocol LocationsServiceProtocol {
    func fetchLocations(for page: Int) async throws -> LocationsModel
}

final class LocationsService: LocationsServiceProtocol {
    private let apiManager: APIManager
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func fetchLocations(for page: Int) async throws -> LocationsModel {
        try await apiManager.request(
            .locations(page: page),
            method: .get,
            responseType: LocationsModel.self
        )
    }
}
