//
//  RealtimeDatabase.swift
//  Shopping List
//
//  Created by Gundars Kokins on 12/05/2021.
//

import Foundation
import Firebase

class RealtimeDatabase: ObservableObject {
    @Published var allShoppingItems: [ShoppingItem] = []
    @Published var baskets: [Basket] = []
    @Published var activeShoppingBasket: [ShoppingItem] = []
    
    var ref: DatabaseReference

    init() {
        ref = Database.database(url: "https://shopping-list-6172f-default-rtdb.europe-west1.firebasedatabase.app/").reference(withPath: "shopping-list/baskets")
        
        populateItems()
    }
    
    private func createDefaultBasket() {
        let basketName = "all items"
        let initialBasket: Any = ["basketName": "All items"]
        let basketRef = self.ref.child(basketName)
        basketRef.setValue(initialBasket)
    }
    
    private func populateItems() {
        ref.observe(.value, with: { snapshot in
            var newItems: [ShoppingItem] = []
            var newBaskets: [Basket] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let basket = Basket(snapshot: snapshot) {
                    newBaskets.append(basket)
                    basket.items.forEach { newItems.append($0) }
                }
            }
            
            if newBaskets.isEmpty {
                self.createDefaultBasket()
            }

            self.baskets = newBaskets
            self.allShoppingItems = newItems
        })
    }
    
    func populateActiveShoppingList(with name: String) {
        switch name {
            case "All items":
                activeShoppingBasket = allShoppingItems
            default:
                if let activeBasket = baskets.filter({ $0.name == name }).first {
                    activeShoppingBasket = activeBasket.items
                }
        }
    }
    
    func saveItem(with name: String, in basket: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let path = "\(basket.lowercased())/items/\(name)"
            let itemRef = self?.ref.child(path)
            
            let shoppingItem = ShoppingItem(name: name,
                                            completed: false,
                                            basket: basket)
            itemRef?.setValue(shoppingItem.toAnyObject())
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { self.allShoppingItems[$0] }
        self.allShoppingItems.remove(atOffsets: offsets)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            itemsToDelete.forEach { $0.ref?.removeValue() }
        }
    }
}
