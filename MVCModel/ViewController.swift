//
//  ViewController.swift
//  MVCModel
//
//  Created by leon on 2018/10/6.
//  Copyright © 2018年 leonlee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    loadItems()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.reloadData()
       
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "try to add something", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add something"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            print(textField)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveItems()
      
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems(){
        
       
        
        do{
           try context.save()
        }catch{
            print(error)
        }

    }
    
    func loadItems(){

        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
}

