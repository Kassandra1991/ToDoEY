//
//  ToDoListTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-20.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTableViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        searchBar.barTintColor = UIColor(hexString: selectedCategory?.color)

    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            print("FatalError: navigation controller does not exist!")
            return
        }
        title = selectedCategory?.name
        navBar.backgroundColor = UIColor(hexString: selectedCategory?.color)
        navBar.tintColor = ContrastColorOf(backgroundColor: UIColor(hexString: selectedCategory?.color), returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: UIColor(hexString: selectedCategory?.color), returnFlat: true)]
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            guard let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row)/CGFloat((items?.count ?? 1))) else {return UITableViewCell()}
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
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
                //realm.delete(item)
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
                        newItem.dateCreated = Date()
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
    
    override func updateModel(at indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else {
            return
        }
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch  {
            print("Error delete category: \(error.localizedDescription)")
        }
    }
}

// MARK: - UISearchBarDelegate

extension ToDoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        items = items?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
