
import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    //this defines the relationship that each Category object has MANY ITEMS
    let items = List<Item>()
    
}
