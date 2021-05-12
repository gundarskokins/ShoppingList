//
//  ItemView.swift
//  Shopping List
//
//  Created by Gundars Kokins on 11/05/2021.
//

import SwiftUI
import Firebase

struct ItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var database: RealtimeDatabase
    @State private var name = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Item name", text: $name)
            }
            .navigationBarTitle("Add item", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "xmark")
                                    },
                                trailing:
                                    Button("Save", action: {
                                        presentationMode.wrappedValue.dismiss()
                                        saveItem()
                                    })
            )
        }
    }
    
    func saveItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let itemRef = database.ref.child(name.lowercased())
            let shoppingItem = ShoppingItem(name: name,
                                            completed: false)
            itemRef.setValue(shoppingItem.toAnyObject())
        }
    }
}
