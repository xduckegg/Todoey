

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext
    
    
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
            self.tableView.reloadData()
            
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
        return categories.count
    }
    //insert data in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.name
        
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK:  Model Manupulation Methods
    //---------------------------------
    func saveCategories(){
        
        do {
            try context.save()
            
        } catch {
            print("Error saving context with \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //if the request is not provided use Item.fetchRequest()
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error Fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
