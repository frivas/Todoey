//
//  Category.swift
//  Todoey
//
//  Created by Francisco Rivas on 29/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var color: String = "flatWhite"
	// This is how relationships between realm objects are created
	let items = List<Item>()
}
