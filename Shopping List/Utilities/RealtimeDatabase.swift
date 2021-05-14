//
//  RealtimeDatabase.swift
//  Shopping List
//
//  Created by Gundars Kokins on 12/05/2021.
//

import Foundation
import Firebase

class RealtimeDatabase: ObservableObject {
    @Published var shoppingItems: [ShoppingItem] = [] {
        didSet {
            shoppingItems.forEach {
                if !baskets.contains($0.basket) {
                    baskets.append($0.basket)
                }
            }
        }
    }
    @Published var baskets: [String] = ["Default"]
    
    
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
    
    func saveItem(with name: String, in basket: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let itemRef = self?.ref.child(name.lowercased())
            let shoppingItem = ShoppingItem(name: name,
                                            completed: false,
                                            basket: basket)
            itemRef?.setValue(shoppingItem.toAnyObject())
        }
    }
}
