//
//  CheckView.swift
//  Shopping List
//
//  Created by Gundars Kokins on 12/05/2021.
//

import SwiftUI

struct CheckView: View {
    @EnvironmentObject var database: RealtimeDatabase
    @State var isChecked: Bool = false
    
    var title: String
    var shoppingItem: ShoppingItem
   
    var body: some View {
        HStack{
            Button(action: {
                isChecked.toggle()
                toggleItem()
            }, label: {
                Image(systemName: isChecked ? "checkmark.circle" : "circle")
            })
            
            Text(title)
        }
    }
    
    func toggleItem() {
        shoppingItem.ref?.updateChildValues([
            "checked": isChecked
        ])
    }
}


struct CheckView_Previews: PreviewProvider {
    static var previews: some View {
        CheckView(title: "Hi", shoppingItem: ShoppingItem(name: "AbC", completed: true))
    }
}
