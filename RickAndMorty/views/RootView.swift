//
//  RootView.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import SwiftUI

enum RootScreen {
    case splash
    case app
}

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    private var apiManager = APIManager()
    private var pointsManager = PointsManager()
    private let bluetoothTradeService = BluetoothTradeService()
    
    @State private var rootScreen: RootScreen = .splash
    @Environment(\.managedObjectContext) private var context // Core Data global context
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                SpaceBackground()
                
                switch rootScreen {
                case .splash:
                    SplashScreen {
                        coordinator.reset()
                        rootScreen = .app
                    }
                case .app:
                    let factory = AppFactory(
                        coordinator: coordinator,
                        apiManager: apiManager,
                        context: context,
                        pointsManager: pointsManager,
                        bluetoothTradeService: bluetoothTradeService
                    )
                    
                    factory.createHomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .home:
                                factory.createHomeView()
                            case .lists:
                                factory.createListsView()
                            case .detail(let id):
                                factory.createDetailView(id: id)
                            case .locations:
                                factory.createLocationsView()
                            case .buyStickers:
                                factory.createBuyStickerView()
                            case .stickerDetail(let sticker):
                                factory.createStickerDetailView(sticker: sticker)
                            case .tradeStickers:
                                factory.createTradeStickersView()
                            case .tradeSearching(let sticker):
                                factory.createTradeSearchingView(sticker: sticker)
                            }
                        }
                    
                }
            }
        }
    }
}
