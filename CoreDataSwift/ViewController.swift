//
//  ViewController.swift
//  CoreDataSwift
//
//  Created by Michael Miles on 1/5/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listItemArray = [ListItem]()
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return listItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let item = listItemArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(listItemArray[indexPath.row])
        listItemArray.remove(at: indexPath.row)
        saveData()
        
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Change ListItem Name", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Update Item", style: .default) { (action) in
//            self.listItemArray[indexPath.row].setValue(textField.text, forKey: "name")
//            self.saveData()
//        }
//        alert.addAction(action)
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "New Item Here"
//            textField = alertTextField
//        }
//        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Create New ListItem", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = ListItem(context: self.context)
            
            newItem.name = textField.text
            self.listItemArray.append(newItem)
            self.saveData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item Here"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData() {
        do {
        try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<ListItem> = ListItem.fetchRequest()
        
        do {
            listItemArray = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
        tableView.reloadData()
    }
}

