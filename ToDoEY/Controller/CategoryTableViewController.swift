//
//  CategoryTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-30.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categories = [CategoryItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor =  #colorLiteral(red: 0.2103916407, green: 0.5888115764, blue: 1, alpha: 1)
        loadCategories()
    }
    
    // MARK: - Alert controller
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category:", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Add", style: .default) { ok in
            guard let new = textField.text else {
                return
            }
            let newItem = CategoryItem(context: self.context)
            newItem.name = new
            self.categories.append(newItem)
            self.saveCategories()
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Manipulation functions
    
    private func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    private func loadCategories(with request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch  {
            print("Error fetch request: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
}
