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
    
    var todoItems: [TodoItem] = []
    var jsonItems : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        enterText.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        if let storedJSON = UserDefaults.standard.object(forKey: "todoItemsList") as? String {
            let decoder = JSONDecoder()
            if let data = storedJSON.data(using: .ascii) {
                todoItems = try! decoder.decode([TodoItem].self, from: data)
            }
        }
    }
    
    @objc func handleTap(){
        enterText.resignFirstResponder()
    }
   
    fileprivate func saveData() {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(todoItems)
        jsonItems = String(data: encoded, encoding: .ascii)!
        UserDefaults.standard.set(jsonItems, forKey: "todoItemsList")
    }
    
    func addNewItem() {
        if enterText.text != "" {
            todoItems.append(TodoItem(todoText: enterText.text!, isComplete: false))
        }
        tableView.reloadData()
        enterText.text = ""
        saveData()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        enterText.becomeFirstResponder()
        addNewItem()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = todoItems[indexPath.row].todoText
        cell?.accessoryType = todoItems[indexPath.row].isComplete ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        todoItems[indexPath.row].isComplete = !todoItems[indexPath.row].isComplete
        tableView.deselectRow(at: indexPath, animated: true)
       saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoItems.remove(at: indexPath.row)
            tableView.reloadData()
            saveData()
        }
    }
}

struct TodoItem: Codable {
    var todoText: String
    var isComplete: Bool = false
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addNewItem()
        return true
    }
}


