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
    @State private var isSaveDisabled = true
    @State private var basketSelection = 0
    @State private var showingSheet = false
    @State private var basketName = ""
    @State var allBaskets: [String] = []
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select basket")) {
                    Picker("Selection", selection: $basketSelection) {
                        
                        ForEach(0..<database.baskets.count, id: \.self) {
                            let basketNames = database.baskets.map { $0.name }
                            Text(basketNames[$0])
                        }
                    }
                    Button("Add basket") {
                        showingSheet = true
                    }
                    .sheet(isPresented: $showingSheet) {
                        BasketView(allBaskets: $allBaskets)
                            .environmentObject(database)
                }
                
                }
                
                Section(header: Text("Enter item name")) {
                    TextField("Item name", text: $name)
                        .onChange(of: name, perform: { value in
                            isSaveDisabled = !(value.count > 0)
                        })
                }
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
                                        database.saveItem(with: name, in: allBaskets[basketSelection])
                                    })
                                    .disabled(isSaveDisabled)
            )

        }
        .onAppear {
            allBaskets = database.baskets.map { $0.name }
        }
    }
}
