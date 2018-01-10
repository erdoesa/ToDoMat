//
//  ViewController.swift
//  ToDoMat
//
//  Created by Arthur Erdös on 09.01.18.
//  Copyright © 2018 SeaSoft. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    
    // MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDoMat item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.items.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "New item to save..."
            textField = alertTextfield
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: model manipulation methods
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error ecnoding items")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding items array")
            }
        }
    }
    
}

