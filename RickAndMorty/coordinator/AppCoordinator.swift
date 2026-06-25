//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import Foundation
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case home
    case lists
    case detail(id: Int)
    case locations
    case buyStickers
    case stickerDetail(sticker: StickerEntity)
    case tradeStickers
    case tradeSearching(sticker: StickerEntity)
}

final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func goToHome() {
        reset()
    }
    
    func goToLists() {
        path.append(AppRoute.lists)
    }
    
    func goToDetail(id: Int) {
        path.append(AppRoute.detail(id: id))
    }
    
    func goToLocations() {
        path.append(AppRoute.locations)
    }
    
    func goToBuyStickers() {
        path.append(AppRoute.buyStickers)
    }
    
    func goToStickerDetail(sticker: StickerEntity) {
        path.append(AppRoute.stickerDetail(sticker: sticker))
    }
    
    func goToTradeStickers() {
        path.append(AppRoute.tradeStickers)
    }
    
    func goToTradeSearching(sticker: StickerEntity) {
        path.append(AppRoute.tradeSearching(sticker: sticker))
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func reset() {
        path.removeLast(path.count)
    }
}
