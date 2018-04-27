//
//  ViewController.swift
//  TableView Demo
//
//  Created by Rick Pearce on 4/20/18.
//  Copyright © 2018 Rick Pearce. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enterText: UITextField!
    
    var todoList = [[String : Bool]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let storedData = UserDefaults.standard.array(forKey: "todoList") as? [[String : Bool]] {
            todoList = storedData
        }
    }
   
    fileprivate func saveData() {
        UserDefaults.standard.set(todoList, forKey: "todoList")
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if enterText.text != "" {
            todoList.append([enterText.text! : false])
        }
        tableView.reloadData()
        enterText.text = ""
        saveData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = (todoList[indexPath.row].first!.key)
        cell?.accessoryType = (todoList[indexPath.row].first!.value) ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        todoList[indexPath.row].updateValue(cell?.accessoryType == .checkmark, forKey: todoList[indexPath.row].first!.key)
        tableView.deselectRow(at: indexPath, animated: true)
       saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.reloadData()
            saveData()
        }
    }
    

}


