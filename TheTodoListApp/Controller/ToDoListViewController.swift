//
//  ViewController.swift
//  TheTodoListApp
//
//  Created by Wynelher Tagayuna on 3/30/23.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    // array of custom type List.
    var listArray = [List]()
    // Give access to AppDelegate as an object. Tap into property persistentContainer and use the viewContext.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?{
        didSet{
            load()// Returns array of List types from store.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Get count of array List.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArray.count
    }
    
    //MARK: - Add each item List to cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        
        let item = listArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Add checkmark when List cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Destroy Cell:
        //context.delete(listArray[indexPath.row])// Delete selected List from listArray from store.
        //listArray.remove(at: indexPath.row)// Remove selected List from listArray.
        
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        save() // Commit new List or any new updates into store.
        
        tableView.deselectRow(at: indexPath, animated: true)// Deselect cell List after pressing.
    }
    
    //MARK: - Add New Data Section.
    @IBAction func addListButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { alertAction in
            
            // The staging area of new List before commiting to store.
            let newList = List(context: self.context)
            newList.title = textField.text!
            newList.done = false
            newList.parentCategory = self.selectedCategory
            
            self.listArray.append(newList)// Append new List to listArray.
            self.save()// Commit new List or any new updates into store.
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New List"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save and Load Section.
    // Commit new List or any new updates into store.
    func save(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    // Returns array of List types from store.
    func load(using request: NSFetchRequest<List> = List.fetchRequest(), and predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            listArray = try context.fetch(request)// Returns the array of List types.
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Section
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<List> = List.fetchRequest()
        
        // Query request based on search bar text.
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        load(using: request, and: predicate)// Fetch request with query.
        tableView.reloadData()
    }
    
    // When search bar is empty, return to original List.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            load()
            DispatchQueue.main.async {// Dismiss keyboard in main thread.
                searchBar.resignFirstResponder()
            }
        }
    }
}

