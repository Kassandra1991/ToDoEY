//
//  ToDoListTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-20.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {
    
    var selectedCategory: CategoryItem? {
        didSet {
            loadItems()
        }
    }
    let realm = try! Realm()
    var items: Results<Item>?
 
   // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor =  #colorLiteral(red: 0.2103916407, green: 0.5888115764, blue: 1, alpha: 1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No added elements"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else {
            return
        }
        do {
            try! realm.write({
                item.isDone = !item.isDone
            })
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
//     MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo item:", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Add", style: .default) { ok in
            guard let new = textField.text else {
                return
            }
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = new
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error adding new item: \(error.localizedDescription)")
                }
                
            }
            self.tableView.reloadData()
        }
        alert.addTextField { tf in
            tf.placeholder = "new item"
            textField = tf
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate

//extension ToDoListTableViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else {
//            return
//        }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
