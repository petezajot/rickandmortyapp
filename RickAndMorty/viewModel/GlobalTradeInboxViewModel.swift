//
//  GlobalTradeInboxViewModel.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 18/06/26.
//

import Foundation
import Combine

protocol GlobalTradeInboxProtocol: ObservableObject {
    var showSnackbar: Bool { get set }
    var snackBarMessage: String { get set }
    var pendingOffer: TradeOffer? { get set }
    var pendingOfferPeer: BluetoothPeer? { get set }
    
    func dismissSnackbar()
}

@MainActor
final class GlobalTradeInboxViewModel: GlobalTradeInboxProtocol {
    @Published var showSnackbar = false
    @Published var snackBarMessage = ""
    @Published var pendingOffer: TradeOffer?
    @Published var pendingOfferPeer: BluetoothPeer?
    
    private let bluetoothTradeService: BluetoothTradeServiceProtocol
    init(bluetoothTradeService: BluetoothTradeServiceProtocol) {
        self.bluetoothTradeService = bluetoothTradeService
        
        self.bluetoothTradeService.onOfferReceived = { [weak self] offer, peer in
            Task { @MainActor in
                self?.handleIncomingOffer(
                    offer,
                    from: peer
                )
            }
        }
    }
    
    func dismissSnackbar() {
        showSnackbar = false
    }
    
    
}

extension GlobalTradeInboxViewModel {
    private func handleIncomingOffer(
        _ offer: TradeOffer,
        from peer: BluetoothPeer
    ) {
        pendingOffer = offer
        pendingOfferPeer = peer
        
        snackBarMessage = "\(peer.name) wants to trade stickers with you."
        
        showSnackbar = true
    }
}
