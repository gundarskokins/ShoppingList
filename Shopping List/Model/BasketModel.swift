//
//  BasketModel.swift
//  Shopping List
//
//  Created by Gundars Kokins on 16/05/2021.
//

import Foundation
import Firebase

struct Basket: Identifiable {
    let id = UUID()
    let ref: DatabaseReference?
    let key: String
    let name: String
    var items: [ShoppingItem] = []
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: AnyObject],
              let name = value["basketName"] as? String else {
            return nil
        }
        
        let childSnapshot = snapshot.childSnapshot(forPath: "items")
        
        for child in childSnapshot.children {
            if let childSnapshot = child as? DataSnapshot,
               let shoppingItem = ShoppingItem(snapshot: childSnapshot) {
                items.append(shoppingItem)
            }
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
    }
}
