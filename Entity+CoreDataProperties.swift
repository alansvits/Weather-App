//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Stas Shetko on 2/10/18.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?

}
