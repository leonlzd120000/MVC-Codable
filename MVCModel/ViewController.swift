//
//  ViewController.swift
//  MVCModel
//
//  Created by leon on 2018/10/6.
//  Copyright © 2018年 leonlee. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
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
        
        print(itemArray[indexPath.row].title)
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "try to add something", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add something"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in

            print(textField)
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveItems()
      
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print(error)
        }

    }
    
    func loadItems(){
           
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
        }
        
    }
    
}

