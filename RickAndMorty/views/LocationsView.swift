//
//  LocationsView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 04/06/26.
//

import SwiftUI

struct LocationsView: View {
    let coordinator: AppCoordinator
    @StateObject private var locationsViewModel: LocationsViewModel
    @State private var currentPage = 1
    
    init(
        coordinator: AppCoordinator,
        locationsViewModel: LocationsViewModel
    ) {
        self.coordinator = coordinator
        _locationsViewModel = StateObject(wrappedValue: locationsViewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            if let locations = locationsViewModel.locations?.results {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(locations, id: \.id) { items in
                            ZStack {
                                SpaceBackground()
                                
                                VStack(spacing: 16) {
                                    Text(items.name)
                                        .font(.orbitronBold(withSize: 16))
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 6)
                                    
                                    Text(items.type)
                                        .font(.orbitronRegular(withSize: 14))
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 6)
                                    
                                    Text(items.dimension)
                                        .font(.orbitronRegular(withSize: 14))
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 6)
                                    
                                    Text("\(items.residents.count) residents")
                                        .font(.orbitronBold(withSize: 16))
                                        .foregroundColor(.green)
                                        .shadow(color: .green, radius: 6)
                                }
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .ignoresSafeArea()
            }
            
        }
        .task {
            await locationsViewModel.fetchLocations(for: currentPage)
        }
    }
}
