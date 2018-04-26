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
   
   
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if enterText.text != "" {
            todoList.append([enterText.text! : false])
        }
        tableView.reloadData()
        enterText.text = ""
        UserDefaults.standard.set(todoList, forKey: "todoList")
    }
    
//    func getData() -> [String] {
//        return todoList
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = (todoList[indexPath.row].keys.first)
        cell?.accessoryType = (todoList[indexPath.row].values.first!) ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        todoList[indexPath.row].updateValue(cell?.accessoryType == .checkmark, forKey: todoList[indexPath.row].keys.first!)
        tableView.deselectRow(at: indexPath, animated: true)
        UserDefaults.standard.set(todoList, forKey: "todoList")
    }
    
    

}


