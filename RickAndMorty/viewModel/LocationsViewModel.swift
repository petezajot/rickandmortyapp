//
//  LocationsViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 04/06/26.
//

import Foundation
import Combine

protocol LocationsViewModelProtocol {
    var isLoading: Bool { get set }
    var error: Error? { get set }
    var locations: LocationsModel? { get set }
    
    func fetchLocations(
        for page: Int
    ) async
}

final class LocationsViewModel: ObservableObject, LocationsViewModelProtocol {
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var locations: LocationsModel?
    
    let service: LocationsService
    init(service: LocationsService) {
        self.service = service
    }
    
    func fetchLocations(for page: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await service.fetchLocations(for: page)
            locations = data
        } catch {
            self.error = error
        }
    }
}
