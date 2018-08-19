

import UIKit
import CoreData
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    // safe to force unwrap it
    
    let realm = try! Realm()
   
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
          loadCategories()
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // create alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen once the user clicked on the add button on the UIAlert
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
            
        }
        alert.addAction(action)
        
        //add text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Datasource Methods
    //-----------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    //insert data in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category?.name ?? "No Categories add yet"
        
        
        return cell
        
    }
    
    // MARK: Tableview Delegate Methods
    //---------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK:  Model Manupulation Methods
    //---------------------------------
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error saving context with \(error)")
        }
        self.tableView.reloadData()
    }
    
    
  
    func loadCategories() {
        
         categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}
