//
//  RealtimeDatabase.swift
//  Shopping List
//
//  Created by Gundars Kokins on 12/05/2021.
//

import Foundation
import Firebase

class RealtimeDatabase: ObservableObject {
    @Published var shoppingItems: [ShoppingItem] = []
    
    var ref: DatabaseReference

    init() {
        ref = Database.database(url: "https://shopping-list-6172f-default-rtdb.europe-west1.firebasedatabase.app/").reference(withPath: "shopping-list")
        
        populateItems()
    }
    
    func populateItems() {
        ref.observe(.value, with: { snapshot in
            var newItems: [ShoppingItem] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let groceryItem = ShoppingItem(snapshot: snapshot) {
                    newItems.append(groceryItem)
                }
            }
            
            self.shoppingItems = newItems
        })
    }
}
