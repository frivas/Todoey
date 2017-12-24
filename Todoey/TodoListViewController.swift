//
//  ViewController.swift
//  Todoey
//
//  Created by Francisco Rivas on 24/12/2017.
//  Copyright © 2017 Francisco Rivas. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemsArray = ["Call Tatiana","Call Mom","Walk the dog"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
		cell.textLabel?.text = itemsArray[indexPath.row]
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
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		var alertSuperTextField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
		
		// the closure in below action happens when the user tap "Add item" button
		let action = UIAlertAction(title: "Add Item", style: .default) {
			(action) in
			self.itemsArray.append(alertSuperTextField.text!)
			self.tableView.reloadData()
		}
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Insert your task"
			alertSuperTextField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	
}

