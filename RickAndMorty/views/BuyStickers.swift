//
//  BuyStickers.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 15/06/26.
//

import SwiftUI
import CoreData

struct BuyStickers: View {
    @StateObject private var charactersViewModel: CharactersViewModel
    @StateObject private var dailyRewardViewModel: DailyRewardViewModel
    @State private var showAlert: Bool = false
    @State private var showPointsOverlay: Bool = false
    @State private var points = 0
    @State private var qty = 0
    @State private var stickersQty = 0
    @State private var showDailyReward: Bool = false
    
    init(
        charactersViewModel: CharactersViewModel,
        dailyRewardViewModel: DailyRewardViewModel
    ) {
        _charactersViewModel = StateObject(wrappedValue: charactersViewModel)
        _dailyRewardViewModel = StateObject(wrappedValue: dailyRewardViewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SpaceBackground()
                
                VStack(spacing: 8) {
                    Button {
                        showDailyReward = true
                    } label: {
                        Text("Daily Wheel")
                            .font(.orbitronBold(withSize: 14))
                            .foregroundColor(.green)
                            .padding(8)
                            .overlay{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.green, lineWidth: 2)
                            }
                    }
                    
                    VStack(alignment: .center) {
                        Image("card")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 150)
                        Text("5 Stickers = 10 pts.")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 6)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height / 3.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 2)
                    }
                    .cornerRadius(8)
                    .onTapGesture {
                        points = 10
                        qty = 1
                        stickersQty = 5
                        showAlert = true
                    }
                    
                    VStack {
                        HStack {
                            Image("card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                            Image("card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                        }
                        Text("10 Stickers = 15 pts.")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 6)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height / 3.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 2)
                    }
                    .cornerRadius(8)
                    .onTapGesture {
                        points = 15
                        qty = 2
                        stickersQty = 10
                        showAlert = true
                    }
                    
                    VStack {
                        HStack {
                            Image("card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                            Image("card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                            Image("card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 150)
                        }
                        Text("15 Stickers = 25 pts.")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 6)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height / 3.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 2)
                    }
                    .cornerRadius(8)
                    .onTapGesture {
                        points = 25
                        qty = 3
                        stickersQty = 15
                        showAlert = true
                    }
                }
                .padding(.horizontal, 10)
                
                if showPointsOverlay {
                    VStack(spacing: 8) {
                        Text("Not enough points")
                            .font(.orbitronBold(withSize: 16))
                            .foregroundColor(.green)
                        
                        Text("Earn more points to buy this pack!")
                            .font(.orbitronRegular(withSize: 12))
                            .foregroundColor(.green.opacity(0.8))
                    }
                    .padding()
                    .background(.black.opacity(0.85))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.green, lineWidth: 2)
                    }
                    .cornerRadius(12)
                    .shadow(color: .green, radius: 8)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(10)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Buy Stickers")
                        .font(.orbitronBold(withSize: 14))
                        .foregroundColor(.green)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    let points = UserDefaultsManager.shared.getInt(forKey: .userPoints)
                    Text("\(points) pts.")
                        .font(.orbitronRegular(withSize: 10))
                        .foregroundColor(.green)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Buy"),
                    message: Text("Would you like to buy \(qty) packs for \(points) points?"),
                    primaryButton: .default(Text("Yes!")) {
                        Task {
                            await charactersViewModel.buyPack(
                                quantity: stickersQty,
                                cost: points
                            )
                            
                            if charactersViewModel.pointsError {
                                charactersViewModel.pointsError = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation {
                                        showPointsOverlay = true
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            showPointsOverlay = false
                                        }
                                    }
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")) {}
                )
            }
            .sheet(isPresented: $charactersViewModel.showPackResult) {
                PackResultView(stickers: charactersViewModel.lastPackStickers)
            }
            .sheet(isPresented: $showDailyReward) {
                DailyRewardWheelView(viewModel: dailyRewardViewModel)
            }
        }
    }
}
