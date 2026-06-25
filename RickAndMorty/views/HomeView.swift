//
//  HomeView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import SwiftUI
import CoreData

struct MenuOptions {
    var image: String
    var name: String
}

struct HomeView: View {
    let coordinator: AppCoordinator
    @StateObject private var charactersViewModel: CharactersViewModel
    
    init(
        coordinator: AppCoordinator,
        charactersViewModel: CharactersViewModel
    ) {
        self.coordinator = coordinator
        _charactersViewModel = StateObject(wrappedValue: charactersViewModel)
    }
    
    let menuArray = [
        MenuOptions(image: "album", name: "Album"),
        MenuOptions(image: "locations", name: "Buy Stickers"),
        MenuOptions(image: "episodes", name: "Trade"),
    ]
    
    var body: some View {
        ZStack {
            SpaceBackground()
            
            VStack(alignment: .center){
                List {
                    ForEach(menuArray, id: \.name) { item in
                        HStack {
                            Image(item.image)
                                .resizable()
                                .frame(width: 125, height: 125)
                                .scaledToFill()
                                .cornerRadius(12)
                                .shadow(color: .green, radius: 6)
                                .clipped()
                            Spacer()
                            Text(item.name)
                                .font(.orbitronBold(withSize: 16))
                                .foregroundColor(.green)
                                .shadow(color: .green, radius: 6)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.green)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 35)
                        .onTapGesture {
                            switch item.name {
                            case "Album":
                                coordinator.goToLists()
                            case "Buy Stickers":
                                coordinator.goToBuyStickers()
                            case "Trade":
                                coordinator.goToTradeStickers()
                            default:
                                break
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 65)
                    }
                }
            }
        }
        .task {
            await charactersViewModel.fetchCharacters(for: 1)
        }
        .onChange(of: charactersViewModel.charactersList?.info.count) { _, newValue in
            guard let newValue else { return }
            UserDefaultsManager.shared.save(newValue, forKey: .albumLength)
        }
        .overlay {
            if charactersViewModel.isLoading {
                Loader()
            }
        }
    }
}
