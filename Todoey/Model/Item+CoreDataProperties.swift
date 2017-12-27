//
//  Item+CoreDataProperties.swift
//  Todoey
//
//  Created by Francisco Rivas on 26/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var title: String?
    @NSManaged public var done: Bool

}
