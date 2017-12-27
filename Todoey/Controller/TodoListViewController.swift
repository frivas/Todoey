//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Rivas on 24/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemsArray = [Item]()
	let userDefaults = UserDefaults.standard
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadData()
		
//		if let items = userDefaults.array(forKey: "TodoListArray") as? [Item] {
//			itemsArray = items
//		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
		
		cell.textLabel?.text = itemsArray[indexPath.row].title
		
		cell.accessoryType = itemsArray[indexPath.row].done ? .checkmark : .none
		
		return cell
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemsArray.count
	}
	
	// getting the row that had been selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// print text of the selected row
		//print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
		// or
		//print(itemsArray[indexPath.row])
		
		itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
		saveData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		var alertSuperTextField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
		
		// the closure in below action happens when the user tap "Add item" button
		let action = UIAlertAction(title: "Add Item", style: .default) {
			(action) in
			
			let newItem = Item()
			newItem.title = alertSuperTextField.text!
			newItem.done = false
			
			self.itemsArray.append(newItem)
			self.saveData()
			
			
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Insert your task"
			alertSuperTextField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	func saveData() {
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemsArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding items array \(error)")
		}
		tableView.reloadData()
	}
	
	func loadData() {
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
				itemsArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding items array \(error)")
			}
			
		}
		tableView.reloadData()
	}
	
}

