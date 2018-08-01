//
//  ViewController.swift
//  iTodo
//
//  Created by Robinson Marquez on 7/13/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        
        return ctx
    }()

    var items : [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        print(FileManager.default.urls(for: .documentDirectory
//            , in: .userDomainMask).first?.appendingPathComponent("Todos.plist"))
        
        
        loadTodos()
        
    }
    
    //MARK: - Tableciew Datasource Methods
    
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
    
    //MARk: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        // To Remove with CoreData
        // context.delete(items[indexPath.row]) //Remove from context before
        // items.remove(at: indexPath.row)
        // saveTodos()
        
        // Another way to update with CoreData
        // items[indexPath.row].setValue(!items[indexPath.row].done, forKey: "done")
        // saveTodos()
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveTodos()
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
            
            // Get the CoreData context
            let newItem = Todo(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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

        do {
            try context.save()
        } catch  {
            print("Error saving todos in context \(error)")
        }
    }
    
    func loadTodos(withRequest request: NSFetchRequest<Todo> = Todo.fetchRequest()) {
        do {
            items = try context.fetch(request)
        } catch  {
            print("error fetching todos \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        if !text.isEmpty  {
            print(text)
//            let predicate = NSPredicate(format: "title CONTAINS %@", text)
//            let sortDesc = NSSortDescriptor(key: "title", ascending: true)
//            request.sortDescriptors = [sortDesc]
//            request.predicate = predicate
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            request.predicate = NSPredicate(format: "title CONTAINS %@", text)
        }
        loadTodos(withRequest: request)
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
