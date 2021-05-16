//
//  BasketView.swift
//  Shopping List
//
//  Created by Gundars Kokins on 14/05/2021.
//

import SwiftUI

struct BasketView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var database: RealtimeDatabase
    
    @State private var isSaveDisabled = true
    @State private var name = ""
    @Binding var allBaskets: [String]
    
    var body: some View {
        Form {
            Section(header: Text("Enter basket name")) {
                TextField("Basket name", text: $name)
                    .onChange(of: name, perform: { value in
                        isSaveDisabled = !(value.count > 0)
                    })
                
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .accentColor(.red)
                    
                    Spacer()
                    
                    Button("Done", action: {
                        presentationMode.wrappedValue.dismiss()
                        addBasket()
                    })
                    .disabled(isSaveDisabled)
                }
            }
            .padding()
        }
    }
    
    func addBasket() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard !allBaskets.contains(name) else { return }
            
            let basketRef = database.ref.child(name.lowercased())
            let basketName: Any = ["basketName": name]
            basketRef.setValue(basketName)
        }
    }
}
