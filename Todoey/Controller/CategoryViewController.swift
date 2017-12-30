//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Francisco Rivas on 28/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
	
	let realm = try! Realm()
	
	var categories: Results<Category>?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		tableView.separatorStyle = .none
	}
	
	//MARK: - TableView DataSource Methods
	// Display categories
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// INherit from SwipreTableViewController class. This method only add morei information to the cell
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let cat = categories?[indexPath.row] {
			cell.textLabel?.text = cat.name
			cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (cat.color))!, returnFlat: true)
			cell.backgroundColor = UIColor(hexString: (cat.color))
		}
		
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}
	
	//MARK: - Data Manipulation methods
	// CRUD
	func save(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving context \(error)")
		}
		tableView.reloadData()
	}
	
	func loadData() {
		categories = realm.objects(Category.self)
		
		tableView.reloadData()
	}
	
	//MARK: - Delete data
	override func updateModel(at indexPath: IndexPath) {
		if let itemToDelete = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemToDelete)
				}
			} catch {
				print("Error saving context \(error)")
			}
		}
	}
	
	// Add new category
	@IBAction func categoryButtonPressed(_ sender: Any) {
		
		var alertSuperTextField = UITextField()
		let randomColor = UIColor.randomFlat.hexValue()
		let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Category", style: .default) {
			(action) in
			
			let newCategory = Category()
			newCategory.name = alertSuperTextField.text!
			newCategory.color = randomColor
			self.save(category: newCategory)
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Insert your category"
			alertSuperTextField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	
	//MARK: - TableView Delegate Methods
	// Methods below will prepare everything so when user taps a category the tableview controller with the items gets called and populated
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categories?[indexPath.row]
		}
	}
}
