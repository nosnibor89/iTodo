//
//  CategoryViewController.swift
//  iTodo
//
//  Created by Robinson Marquez on 7/31/18.
//  Copyright © 2018 Robinson Marquez. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories: [Category] = [Category]()
    var selectedCategory: Category?
    
    lazy var context : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        
        return ctx
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: Add a category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryNametextField = UITextField()
        let categoryAlert = UIAlertController(title: "Add category", message: "You can add a category", preferredStyle: .alert)
        
        let categoryActionAlert = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let category = Category(context: self.context)
            
            category.name = categoryNametextField.text
            category.todos = []
            
            self.categories.append(category)
            
            self.saveCategories();
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedCategory = categories[indexPath.row]
        
        performSegue(withIdentifier: "goToTodoList", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            selectedCategory = categories[indexPath.row]
            destinationController.category = selectedCategory
        }
    }
    
    
    //MARK: Data manipulation methods
    
    func loadCategories(withRequest request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch  {
            print("could not fetch categories \(error)")
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch  {
            print("Error saving categories \(error)")
        }
    }


    
}
