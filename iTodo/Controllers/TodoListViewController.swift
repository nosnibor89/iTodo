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
    
    // Path to the plist file
    let dataFilePath = FileManager.default.urls(for: .documentDirectory
        , in: .userDomainMask).first?.appendingPathComponent("Todos.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        loadTodos()
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
        
        saveTodos()
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
            
            self.saveTodos()
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
    
    func saveTodos(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            
            try data.write(to: dataFilePath!)
        }catch {
            print("error encoding todos")
        }
        
    }
    
    func loadTodos() {
        let decoder = PropertyListDecoder()
        
        do {
            let data = try Data(contentsOf: dataFilePath!)
            items = try decoder.decode([Todo].self, from: data)
        } catch  {
            print("data in todos.plist could not be decoded")
        }
        
    }
    
    
}

