//
//  ViewController.swift
//  TheTodoListApp
//
//  Created by Wynelher Tagayuna on 3/30/23.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var listArray = ["Birthday Gifts","Grocery","School Supplies"]// array of List
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = listArray[indexPath.row]
        return cell
    }
    
    //MARK: - Add checkmark when List cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
            
        tableView.deselectRow(at: indexPath, animated: true)// Deselect cell List after pressing.
    }
    
    //MARK: - Add new List.
    @IBAction func addListButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add List", style: .default) { alertAction in
            self.listArray.append(textField.text!)// Append new List to listArray.
            self.tableView.reloadData()// Reload table view to show new List.
        }
        alert.addTextField { alertTextFiled in
            alertTextFiled.placeholder = "Create New List"
            textField = alertTextFiled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

