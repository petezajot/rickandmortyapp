//
//  TradeMessage.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 16/06/26.
//

import Foundation

struct TradeStickerPayload: Codable, Equatable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String?
}

struct TradeOffer: Codable, Equatable {
    let tradeId: String
    let sticker: TradeStickerPayload
}

struct TradeCounterOffer: Codable, Equatable {
    let tradeId: String
    let originalSticker: TradeStickerPayload
    let counterSticker: TradeStickerPayload
}

struct TradeResponse: Codable, Equatable {
    let tradeId: String
    let accepted: Bool
    let sticker: TradeStickerPayload?
}

enum TradeMessageType: String, Codable {
    case offer
    case counterOffer
    case response
}

struct TradeMessage: Codable {
    let type: TradeMessageType
    let offer: TradeOffer?
    let counterOffer: TradeCounterOffer?
    let response: TradeResponse?
}
