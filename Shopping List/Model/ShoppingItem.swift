//
//  ShoppingItem.swift
//  Shopping List
//
//  Created by Gundars Kokins on 12/05/2021.
//

import Foundation
import Firebase

struct ShoppingItem: Identifiable {
    
    let id = UUID()
    let ref: DatabaseReference?
    let key: String
    let name: String
    var basket: String
    var checked: Bool
    
    init(name: String, completed: Bool, basket: String = "default", key: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.checked = completed
        self.basket = basket
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject],
              let name = value["name"] as? String,
              let basket = value["basket"] as? String,
              let checked = value["checked"] as? Bool else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.checked = checked
        self.basket = basket
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "basket": basket,
            "checked": checked
        ]
    }
}
