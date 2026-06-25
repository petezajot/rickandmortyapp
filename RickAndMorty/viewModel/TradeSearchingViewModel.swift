//
//  TradeSearchingViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation
import Combine

protocol TradeSearchingViewModelProtocol: ObservableObject {
    var foundPeers: [BluetoothPeer] { get set }
    var isSearching: Bool { get set }
    var incomingOffer: TradeOffer? { get set }
    var incomingOfferPeer: BluetoothPeer? { get set }
    var incomingCounterOffer: TradeCounterOffer? { get set }
    var incomingCounterOfferPeer: BluetoothPeer? { get set }
    var duplicatedStickersForCounterOffer: [StickerEntity] { get set }
    var showCounterOfferOptions: Bool { get set }
    var responseMessage: String? { get set }
    
    func startSearching()
    func stopSearching()
    func sendOffer(sticker: StickerEntity, to peer: BluetoothPeer)
    func acceptIncomingOffer()
    func rejectIncomingOffer()
    func clearResponseMessage()
    func showCounterOfferSelection()
    func sendCounterOffer(with sticker: StickerEntity)
    func clearIncomingCounterOffer()
}

@MainActor
final class TradeSearchingViewModel: TradeSearchingViewModelProtocol {
    @Published var foundPeers: [BluetoothPeer] = []
    @Published var isSearching: Bool = false
    @Published var incomingOffer: TradeOffer?
    @Published var incomingOfferPeer: BluetoothPeer?
    @Published var incomingCounterOffer: TradeCounterOffer?
    @Published var incomingCounterOfferPeer: BluetoothPeer?
    @Published var duplicatedStickersForCounterOffer: [StickerEntity] = []
    @Published var showCounterOfferOptions: Bool = false
    @Published var responseMessage: String?
    
    private let bluetoothTradeService: BluetoothTradeServiceProtocol
    private let stickerRepository: StickerRepositoryProtocol
    private var sentOffers: [String: TradeStickerPayload] = [:]
    
    init(
        bluetoothTradeService: BluetoothTradeService,
        stickerRepository: StickerRepositoryProtocol
    ) {
        self.bluetoothTradeService = bluetoothTradeService
        self.stickerRepository = stickerRepository
        
        self.bluetoothTradeService.onPeersChanged = { [weak self] peers in
            Task { @MainActor in
                self?.foundPeers = peers
            }
        }
        
        self.bluetoothTradeService.onOfferReceived = { [weak self] offer, peer in
            Task { @MainActor in
                self?.incomingOffer = offer
                self?.incomingOfferPeer = peer
                self?.showCounterOfferOptions = false
            }
        }
        
        self.bluetoothTradeService.onCounterOfferReceived = { [weak self] counterOffer, peer in
            Task { @MainActor in
                self?.handleCounterOffer(counterOffer, from: peer)
            }
        }
        
        self.bluetoothTradeService.onResponseReceived = { [weak self] response, peer in
            Task{ @MainActor in
                self?.handleTradeResponse(response, from: peer)
            }
        }
    }
    
    func startSearching() {
        isSearching = true
        bluetoothTradeService.startSearching()
    }
    
    func stopSearching() {
        isSearching = false
        bluetoothTradeService.stopSearching()
    }
    
    func sendOffer(sticker: StickerEntity, to peer: BluetoothPeer) {
        guard sticker.quantity > 1 else {
            responseMessage = "This sticker is not available for trade"
            return
        }
        
        let payload = TradeStickerPayload(
            id: Int(sticker.id),
            name: sticker.name ?? "Unknown",
            status: sticker.status ?? "-",
            species: sticker.species ?? "-",
            type: sticker.type ?? "-",
            gender: sticker.gender ?? "-",
            image: sticker.image
        )
        
        let offer = TradeOffer(
            tradeId: UUID().uuidString,
            sticker: payload
        )
        
        sentOffers[offer.tradeId] = payload
        
        bluetoothTradeService.sendOffer(offer, to: peer)
        
        responseMessage = "Offer sent to \(peer.name)"
    }
    
    func acceptIncomingOffer() {
        guard let offer = incomingOffer,
              let peer = incomingOfferPeer else {
            return
        }
        
        stickerRepository.receiveSticker(offer.sticker)
        
        let response = TradeResponse(
            tradeId: offer.tradeId,
            accepted: true,
            sticker: offer.sticker
        )
        
        bluetoothTradeService.sendResponse(response, to: peer)
        
        incomingOffer = nil
        incomingOfferPeer = nil
        responseMessage = "You accepted the offer."
    }
    
    func rejectIncomingOffer() {
        guard let offer = incomingOffer,
              let peer = incomingOfferPeer else { return }
        
        let response = TradeResponse(
            tradeId: offer.tradeId,
            accepted: false,
            sticker: offer.sticker
        )
        
        bluetoothTradeService.sendResponse(response, to: peer)
        
        incomingOffer = nil
        incomingOfferPeer = nil
        showCounterOfferOptions = false
        duplicatedStickersForCounterOffer = []
        
        responseMessage = "You rejected the offer."
    }
    
    func clearResponseMessage() {
        responseMessage = nil
    }
    
    func showCounterOfferSelection() {
        let allStickers = stickerRepository.fetchAllStickers()
        
        duplicatedStickersForCounterOffer = allStickers.filter { sticker in
            sticker.quantity > 1
        }
        
        guard !duplicatedStickersForCounterOffer.isEmpty else {
            responseMessage = "You don't have repeated stickers to offer."
            return
        }
        
        showCounterOfferOptions = true
    }
    
    func sendCounterOffer(with sticker: StickerEntity) {
        guard sticker.quantity > 1 else {
            responseMessage = "This sticker is not available for trade."
            return
        }
        
        guard let offer = incomingOffer,
              let peer = incomingOfferPeer else {
            responseMessage = "There is no incoming offer to answer."
            return
        }
        
        let counterSticker = makePayload(from: sticker)
        
        let counterOffer = TradeCounterOffer(
            tradeId: offer.tradeId,
            originalSticker: offer.sticker,
            counterSticker: counterSticker
        )
        
        bluetoothTradeService.sendCounterOffer(
            counterOffer,
            to: peer
        )
        
        incomingOffer = nil
        incomingOfferPeer = nil
        showCounterOfferOptions = false
        duplicatedStickersForCounterOffer = []
        
        responseMessage = "Counter offer sent to \(peer.name)"
    }
    
    func clearIncomingCounterOffer() {
        incomingCounterOffer = nil
        incomingCounterOfferPeer = nil
    }
}

extension TradeSearchingViewModel {
    private func makePayload(from sticker: StickerEntity) -> TradeStickerPayload {
        TradeStickerPayload(
            id: Int(sticker.id),
            name: sticker.name ?? "Unknown",
            status: sticker.status ?? "-",
            species: sticker.species ?? "-",
            type: sticker.type ?? "-",
            gender: sticker.gender ?? "-",
            image: sticker.image
        )
    }
    
    private func handleTradeResponse(
        _ response: TradeResponse,
        from peer: BluetoothPeer
    ) {
        if response.accepted {
            guard let offeredSticker = sentOffers[response.tradeId] else {
                responseMessage = "\(peer.name) accepted, but local offer was not found."
                return
            }
            
            stickerRepository.removeOneDuplicate(stickerId: offeredSticker.id)
            
            sentOffers.removeValue(forKey: response.tradeId)
            
            responseMessage = "\(peer.name) accepted your trade offer."
        } else {
            sentOffers.removeValue(forKey: response.tradeId)
            responseMessage = "\(peer.name) rejected your trade offer."
        }
    }
    
    private func handleCounterOffer(
        _ counterOffer: TradeCounterOffer,
        from peer: BluetoothPeer
    ) {
        guard sentOffers[counterOffer.tradeId] != nil else {
            responseMessage = "\(peer.name) sent a counter offer, but the original offer was not found."
            return
        }
        
        incomingCounterOffer = counterOffer
        incomingCounterOfferPeer = peer
        
        responseMessage = "\(peer.name) sent a counter offer."
    }
}
