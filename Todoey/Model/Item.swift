

import Foundation
import RealmSwift

class Item: Object {
    
  @objc dynamic  var title : String = ""
  @objc dynamic  var done : Bool = false
  @objc dynamic var dateCreated :Date?
    
    // inverse relationship with parents, "items" is the name of the parent contanier
    //links each item to parent Category, relates to "items List" in Category class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
