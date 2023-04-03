//
//  ViewController.swift
//  TheTodoListApp
//
//  Created by Wynelher Tagayuna on 3/30/23.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var listArray = [List]()// array of List
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "List.plist")// File path for the List.plist.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        load()// Load custom type array from List.plist.
    }

    //MARK: - Get count of array List.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArray.count
    }
    
    //MARK: - Add each item List to cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let list = listArray[indexPath.row]
        cell.textLabel?.text = list.title
        cell.accessoryType = list.done ? .checkmark : .none
        return cell
    }
    
    //MARK: - Add checkmark when List cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        save()// Save the new done boolean property value to List.plist.
    
        tableView.deselectRow(at: indexPath, animated: true)// Deselect cell List after pressing.
    }
    
    //MARK: - Add new List.
    @IBAction func addListButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { alertAction in
            var newList = List()
            newList.title = textField.text!
            self.listArray.append(newList)// Append new List to listArray.
            self.save()// Save the new title string property value to List.plist.
        }
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Create New List"
            textField = alertTextFiled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Encode the array of the custom data types listArray[List] in the List.plist located at dataFilePath.
    func save(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(listArray)
            try data.write(to: dataFilePath!)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    // Decode the array of the custom data types listArray[List] in the List.plist located at dataFilePath.
    func load(){
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                do{
                    listArray = try decoder.decode([List].self, from: data)
                }catch{
                    print(error)
                }
            }
    }
}

