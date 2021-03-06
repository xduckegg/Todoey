

import UIKit

import RealmSwift


class CategoryTableViewController: SwipeTableViewController {
    
    
    
    // safe to force unwrap it
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // create alert
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen once the user clicked on the add button on the UIAlert
            if textField.text!.count > 0 {
                
                let newCategory = Category()
                
                newCategory.name = textField.text!
                
                self.save(category: newCategory)
            }
            
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
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
    override func updateModel(at indexPath: IndexPath) {
        
        
        if let categoryToDelete = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryToDelete)
                    
                }
            } catch{
                print("error deleteing category \(error)")
            }
            
        }
    }
    
}
