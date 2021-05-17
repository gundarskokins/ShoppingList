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
    @Published var selectedBasket = "All items"
    
    var ref: DatabaseReference
    var url: String
    var path: String

    init(url: String, path: String) {
        self.url = url
        self.path = path
        self.ref = Database.database(url: url).reference(withPath: path)
        
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
            
            self.populateActiveShoppingList(with: self.selectedBasket)
        })
    }
    
    func populateActiveShoppingList(with name: String) {
        selectedBasket = name
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
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
    
    func addBasket(with name: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard !self.baskets.map({ $0.name }).contains(name) else { return }
            
            let basketRef = self.ref.child(name.lowercased())
            let basketName: Any = ["basketName": name]
            basketRef.setValue(basketName)
        }
    }
}
