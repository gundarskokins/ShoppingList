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
                        allBaskets.append(name)
                    })
                    .disabled(isSaveDisabled)
                }
            }
            .padding()
        }
    }
}
