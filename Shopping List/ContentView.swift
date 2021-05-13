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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(database.shoppingItems) { item in
                    CheckView(isChecked: item.checked, title: item.name, shoppingItem: item)
                }
                .onDelete(perform: deleteItem)
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .sheet(isPresented: $showingSheet) {
                        ItemView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { database.shoppingItems[$0] }
        database.shoppingItems.remove(atOffsets: offsets)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            itemsToDelete.forEach { $0.ref?.removeValue() }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
