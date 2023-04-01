//
//  CategoryTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-30.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<CategoryItem>?
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor =  #colorLiteral(red: 0.2103916407, green: 0.5888115764, blue: 1, alpha: 1)
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            print("FatalError: navigation controller does not exist!")
            return
        }
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    // MARK: - Alert controller
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category:", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Add", style: .default) { ok in
            guard let new = textField.text else {
                return
            }
            let newItem = CategoryItem()
            newItem.name = new
            newItem.color = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newItem)
        }
        alert.addTextField { tf in
            tf.placeholder = "new category"
            textField = tf
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        guard let category = categories?[indexPath.row] else {return UITableViewCell()}
        cell.textLabel?.text = category.name
        guard let color = UIColor(hexString: category.color) else {return UITableViewCell()}
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Manipulation functions
    
    private func saveCategories(category: CategoryItem) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    private func loadCategories() {
        categories = realm.objects(CategoryItem.self)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        guard let category = categories?[indexPath.row] else {
            return
        }
        do {
            try self.realm.write {
                self.realm.delete(category)
            }
        } catch  {
            print("Error delete category: \(error.localizedDescription)")
        }
    }
}
