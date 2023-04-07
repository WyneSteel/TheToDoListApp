//
//  CategoryTableViewController.swift
//  TheTodoListApp
//
//  Created by Wynelher Tagayuna on 4/4/23.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    //MARK: - Get count of array Category.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    //MARK: - Add each item Category to cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Destroy Cell:
        //context.delete(categoryArray[indexPath.row])// Delete selected Category from categoryArray from store.
        //categoryArray.remove(at: indexPath.row)// Remove selected Category from categoryArray.
        
        performSegue(withIdentifier: "goToList", sender: self)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Note: Don't add tableView.deselectRow(at: , animated: ) at tableView(didSelectRowAt) method.
        if let indexPath = tableView.indexPathForSelectedRow{// Get index path of selected cell.
            destinationVC.selectedCategory  = categoryArray[indexPath.row]
        }else{
        }
    }
    
    //MARK: - Add New Data Section.
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { alertAction in
            // The staging area of new Category before commiting to store.
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categoryArray.append(newCategory)// Append new Category to listArray.
            self.save()// Commit new Category or any new updates into store.
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Save and Load Section.
    // Commit new Category or any new updates into store.
    func save(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    // Returns array of Category types from store.
    func load(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)// Returns the array of Category types.
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}
