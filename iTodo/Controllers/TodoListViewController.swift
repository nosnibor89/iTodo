//
//  ViewController.swift
//  iTodo
//
//  Created by Robinson Marquez on 7/13/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {


    let realm = try! Realm()
    var items : Results<Todo>?
    var category : Category? {
        didSet {
            loadTodos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Tableciew Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType =  item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No todos found"
            cell.accessoryType = .none
            
        }
        	
        return cell
    }
    
    //MARk: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {

                    //To Delete
                    //realm.delete(item)
                    
                    // Update
                    item.done = !item.done
                }
            }catch{
                print("Error updating status \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo", message: "", preferredStyle: .alert)
        
        // Handle action
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What happens when the user clicks the button
            
            do {
                try self.realm.write {
                    let newItem = Todo()
                    newItem.title = textField.text!
                    newItem.done = false
                    self.category?.todos.append(newItem)
                }
            } catch  {
                print("Error saving todos in realm \(error)")
            }
            
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
    
    func save(_ todo: Todo){
        do {
            try realm.write {
                realm.add(todo)
            }
        } catch  {
            print("Error saving todos in realm \(error)")
        }
    }
    
    func loadTodos() {
        items = category?.todos.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }

        if !text.isEmpty  {
            print(text)
//            items = items?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "title", ascending: true)
            items = items?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "createdAt", ascending: true)
        }
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodos()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
