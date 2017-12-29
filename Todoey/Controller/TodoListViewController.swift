//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Rivas on 24/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	@IBOutlet weak var searchBarOutlet: UISearchBar!
	
	var itemsArray = [Item]()
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	let userDefaults = UserDefaults.standard
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	var selectedCategory: Category? {
		didSet {
			loadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		
		// below method performs an update on the selected row in this case sets the done flag to true
		itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done
		
		// Deleting data from the persistent container it always has to be followed by a context.save
		// the order is very important
		//context.delete(itemsArray[indexPath.row])
		//itemsArray.remove(at: indexPath.row)
		
		saveData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		var alertSuperTextField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
		
		// the closure in below action happens when the user tap "Add item" button
		let action = UIAlertAction(title: "Add Item", style: .default) {
			(action) in
			
			
			let newItem = Item(context: self.context)
			newItem.title = alertSuperTextField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			
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
		do {
			try self.context.save()
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	// This modified function allows to call it without any parameter as there is one assigned by default
	func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		// be sure to always specify the data type of the request
		
		// TODO: Fix when there is no parentCategory.name value
		let categoryPredicate = NSPredicate(format: "parentCaterogy.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
		} else {
			request.predicate = categoryPredicate
		}

		do {
			itemsArray = try context.fetch(request)
		} catch {
			print("Error fetching data from container \(error)")
		}
		tableView.reloadData()
	}
	
}

extension TodoListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadData(with: request, predicate: predicate)
		
	}
	// Reload the data when there is no text to search for or tapping on the X
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadData()
			
			// Below method performs the resigning method in the main thread so the keyboard goes away immediately
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
		}
	}
}

