//
//  CategoryViewController.swift
//  iTodo
//
//  Created by Robinson Marquez on 7/31/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: Add a category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryNametextField = UITextField()
        let categoryAlert = UIAlertController(title: "Add category", message: "You can add a category", preferredStyle: .alert)
        
        let categoryActionAlert = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let category = Category()
            
            category.name = categoryNametextField.text!

            self.save(category);
            self.tableView.reloadData()
        }
        
        categoryAlert.addTextField { (textField) in
            textField.placeholder = "Some category like \"Dogs\""
            categoryNametextField = textField
        }
        
        categoryAlert.addAction(categoryActionAlert)
        
        present(categoryAlert, animated: true, completion: nil)
    }
    
    //MARK: TableView data source  & delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            selectedCategory = categories?[indexPath.row]
            destinationController.category = selectedCategory
        }
    }
    
    
    //MARK: Data manipulation methods
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(_ category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error saving categories \(error)")
        }
    }
}
