//
//  ViewController.swift
//  iTodo
//
//  Created by Robinson Marquez on 7/13/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

//    var items = ["Find Mike", "Buy Eggs" , "Destroy Demogorgon"]
    var items : [Todo] = []

    let defaults  = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let newItem = Todo()
        newItem.title = "Find Mike"
        
        let newItem2 = Todo()
        newItem2.title = "Buy Eggs"
        
        let newItem3 = Todo()
        newItem3.title = "Destroy Demogorgon"
        
        items.append(newItem)
        items.append(newItem2)
        items.append(newItem3)
        
        
        if let currentItems = self.defaults.array(forKey: "TodoList") as? [Todo] {
            self.items = currentItems
        }
    }
    
    //MARK - Tableciew Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done ? .checkmark : .none
        	
        return cell
    }
    
    //MARk - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        items[indexPath.row].done = !items[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        
        // Handle action
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What happens when the user clicks the button
            let newItem = Todo()
            newItem.title = textField.text!
            self.items.append(newItem)
            
            self.defaults.set(self.items, forKey: "TodoList")
            self.tableView.reloadData()
        }
        
        // Handle text file
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

