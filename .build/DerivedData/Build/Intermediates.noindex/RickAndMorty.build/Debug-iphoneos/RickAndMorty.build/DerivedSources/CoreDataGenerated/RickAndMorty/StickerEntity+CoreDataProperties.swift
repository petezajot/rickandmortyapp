//
//  StickerEntity+CoreDataProperties.swift
//  
//
//  Created by Sergio Garcia Vargas on 23/06/26.
//
//  This file was automatically generated and should not be edited.
//

public import Foundation
public import CoreData


public typealias StickerEntityCoreDataPropertiesSet = NSSet

extension StickerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StickerEntity> {
        return NSFetchRequest<StickerEntity>(entityName: "StickerEntity")
    }

    @NSManaged public var gender: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var species: String?
    @NSManaged public var status: String?
    @NSManaged public var type: String?

}

extension StickerEntity : Identifiable {

}
