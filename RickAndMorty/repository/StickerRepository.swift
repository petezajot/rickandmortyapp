//
//  StickerRepository.swift
//  RickAndMorty
//
//  Created by Sergio Garcia Vargas on 15/06/26.
//

import Foundation
import CoreData

protocol StickerRepositoryProtocol {
    func saveStickers(from characters: [Character])
    func fetchSticker(id: Int) -> StickerEntity?
    func fetchAllStickers() -> [StickerEntity]
    func removeOneDuplicate(stickerId: Int)
    func receiveSticker(_ sticker: TradeStickerPayload)
}

final class StickerRepository: StickerRepositoryProtocol {
    internal var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveStickers(from characters: [Character]) {
        for character in characters {
            if let existingSticker = fetchSticker(id: character.id) {
                existingSticker.quantity += 1
            } else {
                let sticker = StickerEntity(context: context)
                sticker.id = Int64(character.id)
                sticker.name = character.name
                sticker.status = character.status
                sticker.species = character.species
                sticker.type = character.type
                sticker.gender = character.gender
                sticker.image = character.image
                sticker.quantity = 1
            }
        }
        
        do {
            try context.save()
            print("Stickers saved")
            let all = fetchAllStickers()
            print("Total stickers after save:", all.count)
        } catch {
            print("Save error: \(error)")
        }
    }
    
    func fetchSticker(id: Int) -> StickerEntity? {
        let request = StickerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch error: \(error)")
            return nil
        }
    }
    
    func fetchAllStickers() -> [StickerEntity] {
        let request = StickerEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch all error: \(error)")
            return []
        }
    }
    
    func removeOneDuplicate(stickerId: Int) {
        guard let sticker = fetchSticker(id: stickerId) else {
            print("Sticker not found: \(stickerId)")
            return
        }
        
        guard sticker.quantity > 1 else {
            print("Cannot trade sticker because quantity is not duplicated: \(stickerId)")
            return
        }
        
        sticker.quantity -= 1
        
        do {
            try context.save()
            print("Removed one duplicate sticker: \(stickerId)")
        } catch {
            print("Remove duplicate error: \(error.localizedDescription)")
        }
    }
    
    func receiveSticker(_ sticker: TradeStickerPayload) {
        if let existingSticker = fetchSticker(id: sticker.id) {
            existingSticker.quantity += 1
        } else {
            let newSticker = StickerEntity(context: context)
            newSticker.id = Int64(sticker.id)
            newSticker.name = sticker.name
            newSticker.status = sticker.status
            newSticker.species = sticker.species
            newSticker.type = sticker.type
            newSticker.gender = sticker.gender
            newSticker.image = sticker.image
            newSticker.quantity = 1
        }
        
        do {
            try context.save()
            print("Received sticker saved: \(sticker.id)")
        } catch {
            print("Received sticker error: \(error.localizedDescription)")
        }
    }
}
