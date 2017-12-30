//
//  Item.swift
//  Todoey
//
//  Created by Francisco Rivas on 29/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title: String = ""
	@objc dynamic var done: Bool = false
	@objc dynamic var createdDate: Date = Date()
	@objc dynamic var color: String = "flatWhite"
	// This is how the reverse relation between realm objects is declared
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
