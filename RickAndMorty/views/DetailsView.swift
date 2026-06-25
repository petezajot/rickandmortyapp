//
//  DetailsView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import SwiftUI

struct DetailsView: View {
    let coordinator: AppCoordinator
    @StateObject private var charactersViewModel: CharactersViewModel
    let id: Int
    
    init(coordinator: AppCoordinator, charactersViewModel: CharactersViewModel, id: Int) {
        self.coordinator = coordinator
        _charactersViewModel = StateObject(wrappedValue: charactersViewModel)
        self.id = id
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                if let img = charactersViewModel.character?.image {
                    AsyncImage(url: URL(string: img)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                HStack {
                    VStack {
                        Text("Name: \(charactersViewModel.character?.name ?? "Unknown")")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 8)
                        Text("Status: \(charactersViewModel.character?.status ?? "Unknown")")
                            .font(.orbitronRegular(withSize: 14))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 8)
                        Text("Species: \(charactersViewModel.character?.species ?? "Unknown")")
                            .font(.orbitronRegular(withSize: 14))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 8)
                        Text("Origin: \(charactersViewModel.character?.origin.name ?? "Unknown")")
                            .font(.orbitronRegular(withSize: 14))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 8)
                    }
                    .padding(.leading, 15)
                    Spacer()
                    Image(systemName: "heart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .padding(.trailing, 25)
                        .onTapGesture {
                            print("Me like it! (character id: \(id))")
                            print("Name: \(charactersViewModel.character?.name ?? "Unknown")")
                            print("Status: \(charactersViewModel.character?.status ?? "Unknown")")
                            print("Species: \(charactersViewModel.character?.species ?? "Unknown")")
                            print("Origin: \(charactersViewModel.character?.origin.name ?? "Unknown")")
                            print("Image: \(charactersViewModel.character?.image ?? "Unknown")")
                        }
                }
                .frame(width: proxy.size.width, height: 100, alignment: .center)
                .background(.black.opacity(0.7))
                .padding()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
        .overlay {
            if charactersViewModel.isLoading {
                Loader()
            }
        }
        .task {
            await charactersViewModel.fetchSingleCharacter(withId: id)
        }
    }
}
