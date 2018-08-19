

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
            navigationItem.title = selectedCategory?.name
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - Tableview Datasource Methods
    //-----------------------------------
    
    // how many items in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //insert data in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //display check mark using tinary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "Fail"
        }
        
        return cell
        
    }
    
    // MARK: Tableview Delegate Methods
    //---------------------------------
    
    //when a cell is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Trigger a checkmark
        if let item = todoItems?[indexPath.row]{
            do {

                try realm.write{
                    item.done = !item.done

                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //to stop the permenant highlight when we select a cell
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add New Items
    //--------------------
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // create alert
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // what will happen once the user clicked on the add button on the UIAlert
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        
                        let newItem = Item()
                        
                        newItem.title = textField.text!

                        newItem.dateCreated = Date()

                        currentCategory.items.append(newItem)
                        
                    }
                    
                } catch {
                    print("Error saving context with \(error)")
                }
                self.tableView.reloadData()
            }
            
        }
        //add text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK:  Model Manupulation Methods
    //---------------------------------
    

    func loadItems() {
        
        // load the items that exsists in parent Category and sort them by title
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        
        if let itemToDelete = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(itemToDelete)
                    
                }
            } catch{
                print("error deleteing category \(error)")
            }
            
        }
    }
    
   
    
}
//MARK:  Search bar  methods
//---------------------------------
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty{
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
        }
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != 0 {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }else{
            //move the keyboard back and lose the focus on the seacrh bar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
    
        
    }
}
