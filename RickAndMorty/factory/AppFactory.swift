//
//  AppFactory.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import Foundation
import SwiftUI
import CoreData

struct AppFactory {
    let coordinator: AppCoordinator
    let apiManager: APIManager
    let context: NSManagedObjectContext // Core Data global context
    let pointsManager: PointsManager
    let bluetoothTradeService: BluetoothTradeService
    
    init(
        coordinator: AppCoordinator,
        apiManager: APIManager,
        context: NSManagedObjectContext,
        pointsManager: PointsManager,
        bluetoothTradeService: BluetoothTradeService
    ) {
        self.coordinator = coordinator
        self.apiManager = apiManager
        self.context = context
        self.pointsManager = pointsManager
        self.bluetoothTradeService = bluetoothTradeService
    }
    
    func createHomeView() -> some View {
        return HomeView(
            coordinator: coordinator,
            charactersViewModel: makeCharactersViewModel()
        )
    }
    
    func createListsView() -> some View {
        return ListsView(
            coordinator: coordinator,
            charactersViewModel: makeCharactersViewModel()
        )
    }
    
    func createDetailView(id: Int) -> some View {
        return DetailsView(
            coordinator: coordinator,
            charactersViewModel: makeCharactersViewModel(),
            id: id
        )
    }
    
    func createLocationsView() -> some View {
        return LocationsView(
            coordinator: coordinator,
            locationsViewModel: makeLocationsViewModel()
        )
    }
    
    func createBuyStickerView() -> some View {
        let dailyRewardManager = DailyRewardManager(pointsManager: pointsManager)
        let dailyRewardViewModel = DailyRewardViewModel(dailyRewardManager: dailyRewardManager)
        
        return BuyStickers(
            charactersViewModel: makeCharactersViewModel(),
            dailyRewardViewModel: dailyRewardViewModel
        )
    }
    
    func createStickerDetailView(sticker: StickerEntity) -> some View {
        return StickerDetail(sticker: sticker)
    }
    
    func createTradeStickersView() -> some View {
        return TradeStickersView(
            coordinator: coordinator,
            viewModel: makeTradeStickersViewModel()
        )
    }
    
    func createTradeSearchingView(sticker: StickerEntity) -> some View {
        return TradeSearchingView(
            sticker: sticker,
            viewModel: makeTradeSearchingViewModel()
        )
    }
    
    private func makeCharactersViewModel() -> CharactersViewModel {
        let service = CharactersService(apiManager: apiManager)
        let stickerRepository = StickerRepository(context: context)
        
        return CharactersViewModel(
            service: service,
            stickerRepository: stickerRepository,
            pointsManager: pointsManager
        )
    }
    
    private func makeLocationsViewModel() -> LocationsViewModel {
        let service = LocationsService(apiManager: apiManager)
        return LocationsViewModel(service: service)
    }
    
    private func makeTradeStickersViewModel() -> TradeStickersViewModel {
        let stickerRepository = StickerRepository(context: context)
        return TradeStickersViewModel(stickerRepository: stickerRepository)
    }
    
    private func makeTradeSearchingViewModel() -> TradeSearchingViewModel {
        let stickerRepository = StickerRepository(context: context)
        
        return TradeSearchingViewModel(
            bluetoothTradeService: bluetoothTradeService,
            stickerRepository: stickerRepository
        )
    }
}
