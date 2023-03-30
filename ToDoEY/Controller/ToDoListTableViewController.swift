//
//  ToDoListTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-20.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    
    var selectedCategory: CategoryItem? {
        didSet {
            //loadItems()
        }
    }

    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
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
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        items[indexPath.row].isDone = !items[indexPath.row].isDone
        //items[indexPath.row].setValue("Complete", forKey: "title")
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    // MARK: - Add new items
    
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add new ToDo item:", message: "", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "Add", style: .default) { ok in
//            guard let new = textField.text else {
//                return
//            }
//            let newItem = Item(context: self.context)
//            newItem.title = new
//            newItem.isDone = false
//            newItem.parentCategory = self.selectedCategory
//            self.items.append(newItem)
//            self.saveItems()
//        }
//        alert.addTextField { tf in
//            tf.placeholder = "new item"
//            textField = tf
//        }
//        alert.addAction(ok)
//        present(alert, animated: true)
//    }
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
//    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        guard let name = selectedCategory?.name else {
//            return
//        }
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", name)
//        if let additionalPredicat = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicat, categoryPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        do {
//            items = try context.fetch(request)
//        } catch  {
//            print("Error fetch request: \(error.localizedDescription)")
//        }
//        tableView.reloadData()
//    }
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
