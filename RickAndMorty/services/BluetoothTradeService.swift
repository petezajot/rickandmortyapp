//
//  BluetoothTradeService.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation
import MultipeerConnectivity
import UIKit

/**
 Responsabilidades de "BluetoothTradeService":
 buscar dispositivos cercanos
 anunciar este dispositivo
 conectar sesiones
 enviar mensajes
 recibir mensajes
 avisar al ViewModel con callbacks
 */

protocol BluetoothTradeServiceProtocol: AnyObject {
    var foundPeers: [BluetoothPeer] { get }
    var onPeersChanged: (([BluetoothPeer]) -> Void)? { get set }
    var onOfferReceived: ((TradeOffer, BluetoothPeer) -> Void)? { get set }
    var onCounterOfferReceived: ((TradeCounterOffer, BluetoothPeer) -> Void)? { get set }
    var onResponseReceived: ((TradeResponse, BluetoothPeer) -> Void)? { get set }
    
    func startSearching()
    func stopSearching()
    func sendOffer(_ offer: TradeOffer, to peer: BluetoothPeer)
    func sendCounterOffer(_ counterOffer: TradeCounterOffer, to peer: BluetoothPeer)
    func sendResponse(_ response: TradeResponse, to peer: BluetoothPeer)
}

final class BluetoothTradeService: NSObject, BluetoothTradeServiceProtocol {
    private let serviceType = "rm-trade"
    
    private let peerID: MCPeerID
    private let session: MCSession
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser
    
    private var discoveredPeers: [MCPeerID] = []
    private var pendingMessages: [String: Data] = [:]
    
    var onPeersChanged: (([BluetoothPeer]) -> Void)?
    var onOfferReceived: ((TradeOffer, BluetoothPeer) -> Void)?
    var onCounterOfferReceived: ((TradeCounterOffer, BluetoothPeer) -> Void)?
    var onResponseReceived: ((TradeResponse, BluetoothPeer) -> Void)?
    
    var foundPeers: [BluetoothPeer] { // Explicar
        discoveredPeers.map {
            BluetoothPeer(
                id: $0.displayName,
                name: $0.displayName
            )
        }
    }
    
    
    override init() {
        self.peerID = MCPeerID(displayName: UIDevice.current.name) // Explicar
        
        self.session = MCSession( // Explicar
            peer: peerID,
            securityIdentity: nil,
            encryptionPreference: .required
        )
        
        self.advertiser = MCNearbyServiceAdvertiser( // Explicar
            peer: peerID,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        self.browser = MCNearbyServiceBrowser( // Explicar
            peer: peerID,
            serviceType: serviceType
        )
        
        super.init()
        
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
    }
    
    func startSearching() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func stopSearching() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func sendOffer(_ offer: TradeOffer, to peer: BluetoothPeer) {
        let message = TradeMessage(
            type: .offer,
            offer: offer,
            counterOffer: nil,
            response: nil
        )
        
        send(message: message, to: peer)
    }
    
    func sendCounterOffer(_ counterOffer: TradeCounterOffer, to peer: BluetoothPeer) {
        let message = TradeMessage(
            type: .counterOffer,
            offer: nil,
            counterOffer: counterOffer,
            response: nil
        )
        
        send(message: message, to: peer)
    }
    
    func sendResponse(_ response: TradeResponse, to peer: BluetoothPeer) {
        let message = TradeMessage(
            type: .response,
            offer: nil,
            counterOffer: nil,
            response: response
        )
        
        send(message: message, to: peer)
    }
    
    private func send(message: TradeMessage, to peer: BluetoothPeer) {
        guard let data = try? JSONEncoder().encode(message) else {
            print("Could not encode trade message.")
            return
        }
        
        if let connectedPeer = session.connectedPeers.first(where: { $0.displayName == peer.id }) {
            send(data: data, to: connectedPeer)
            return
        }
        
        guard let peerToInvite = discoveredPeers.first(where: { $0.displayName == peer.id }) else {
            print("Peer not found: \(peer.name)")
            return
        }
        
        pendingMessages[peer.id] = data
        
        browser.invitePeer(
            peerToInvite,
            to: session,
            withContext: nil,
            timeout: 30
        )
    }
    
    private func send(data: Data, to peerID: MCPeerID) {
        do {
            try session.send(
                data,
                toPeers: [peerID],
                with: .reliable
            )
        } catch {
            print("Send error: \(error.localizedDescription)")
        }
    }
    
    private func addPeerIfNeeded(_ peerID: MCPeerID) {
        guard !discoveredPeers.contains(peerID) else { return }
        
        discoveredPeers.append(peerID)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onPeersChanged?(self.foundPeers)
        }
    }
    
    private func removePeer(_ peerID: MCPeerID) {
        discoveredPeers.removeAll { $0 == peerID }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.onPeersChanged?(self.foundPeers)
        }
    }
    
    private func makeBluetoothPeer(from peerID: MCPeerID) -> BluetoothPeer {
        BluetoothPeer(
            id: peerID.displayName,
            name: peerID.displayName
        )
    }
    
    private func handleReceivedData(_ data: Data, from peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(TradeMessage.self, from: data) else {
            print("Could not decode trade message")
            return
        }
        
        let peer = makeBluetoothPeer(from: peerID)
        
        DispatchQueue.main.async { [weak self] in
            switch message.type {
            case .offer:
                guard let offer = message.offer else { return }
                self?.onOfferReceived?(offer, peer)
                
            case .counterOffer:
                guard let counterOffer = message.counterOffer else { return }
                self?.onCounterOfferReceived?(counterOffer, peer)
                
            case .response:
                guard let response = message.response else { return }
                self?.onResponseReceived?(response, peer)
            }
        }
    }
}

extension BluetoothTradeService: MCNearbyServiceBrowserDelegate {
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String : String]?
    ) {
        addPeerIfNeeded(peerID)
    }
    
    func browser(
        _ browser: MCNearbyServiceBrowser,
        lostPeer peerID: MCPeerID
    ) {
        removePeer(peerID)
    }
    
    func browser(
        _ browser: MCNearbyServiceBrowser,
        didNotStartBrowsingForPeers error: Error
    ) {
        print("Browser Error: ", error)
    }
}

extension BluetoothTradeService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        invitationHandler(true, session)
    }
    
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didNotStartAdvertisingPeer error: any Error
    ) {
        print("Advertiser error: ", error.localizedDescription)
    }
}

extension BluetoothTradeService: MCSessionDelegate {
    func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        if state == .connected {
            let peerKey = peerID.displayName
            
            if let data = pendingMessages[peerKey] {
                send(data: data, to: peerID)
                pendingMessages.removeValue(forKey: peerKey)
            }
        }
    }
    
    func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        handleReceivedData(data, from: peerID)
    }
    
    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {}
    
    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {}
    
    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?) {}
    
    func session(
        _ session: MCSession,
        didReceiveCertificate certificate: [Any]?,
        fromPeer peerID: MCPeerID,
        certificateHandler: @escaping (Bool) -> Void
    ) {
        certificateHandler(true)
    }
}
