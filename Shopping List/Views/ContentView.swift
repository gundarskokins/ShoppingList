//
//  ContentView.swift
//  Shopping List
//
//  Created by Gundars Kokins on 10/05/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var database: RealtimeDatabase
    @State private var showingSheet = false
    @State private var basketName = "All items"
    
    var body: some View {
        NavigationView {
            VStack {
                DropdownPicker(title: "Select basket", selection: $basketName, options: database.baskets.map { $0.name })
                List {
                    ForEach(database.activeShoppingBasket) { item in
                        CheckView(isChecked: item.checked, title: item.name, shoppingItem: item)
                    }
                    .onDelete(perform: database.deleteItem)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .sheet(isPresented: $showingSheet) {
                        ItemView()
                            .environmentObject(database)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .onChange(of: basketName, perform: { value in
            database.populateActiveShoppingList(with: basketName)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
