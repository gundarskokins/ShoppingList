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
            List(database.shoppingItems) { item in
                CheckView(isChecked: item.checked, title: item.name, shoppingItem: item)
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
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
