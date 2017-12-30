//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Rivas on 24/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
	
	@IBOutlet weak var searchBarOutlet: UISearchBar!
	
	var todoItems: Results<Item>?
	let realm = try! Realm()
	
	var selectedCategory: Category? {
		didSet {
			loadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		title = selectedCategory!.name
		guard let colorHex = selectedCategory?.color else { fatalError() }
		updateNavBar(withHexCode: colorHex)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		updateNavBar(withHexCode: "1D9BF6")
	}
	
	func updateNavBar(withHexCode colorHexCode: String) {
		searchBarOutlet.barTintColor = UIColor(hexString: colorHexCode)
		searchBarOutlet.tintColor = UIColor(hexString: colorHexCode)
		
		guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller failed")}
		
		guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
		
		navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
		navBar.barTintColor = navBarColor
		navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = todoItems?[indexPath.row] {
			
			if let color = UIColor(hexString: (selectedCategory!.color))?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat((todoItems!.count))) {
				cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
				cell.backgroundColor = color
			}
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
		} else {
			cell.textLabel?.text = "No items added yet"
		}
		
		return cell
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}
	
	// getting the row that had been selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					// To delete
					//realm.delete(item)
					item.done = !item.done
				}
			} catch {
				print("Error saving done status \(error)")
			}
		}
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		
		var alertSuperTextField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
		
		// the closure in below action happens when the user tap "Add item" button
		let action = UIAlertAction(title: "Add Item", style: .default) {
			(action) in
			if let currentCategory = self.selectedCategory {
				do {
					try self.realm.write {
						let newItem = Item()
						newItem.title = alertSuperTextField.text!
						newItem.createdDate = Date()
						newItem.color = currentCategory.color
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving new items, \(error)")
				}
			}
			self.tableView.reloadData()
			
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Insert your task"
			alertSuperTextField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	// This modified function allows to call it without any parameter as there is one assigned by default
	func loadData() {
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}
	override func updateModel(at indexPath: IndexPath) {
		if let itemToDelete = self.todoItems?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemToDelete)
				}
			} catch {
				print("Error saving context \(error)")
			}
		}
	}
}

extension TodoListViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
		
		tableView.reloadData()
		
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
