//
//  Utils.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 15/06/26.
//

import Foundation

enum StickerGenerator {
    static func generatePack(
        quantity: Int,
        albumLength: Int
    ) -> String {
        (1...albumLength)
            .shuffled()
            .prefix(quantity)
            .map(String.init)
            .joined(separator: ",")
    }
}
