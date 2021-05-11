//
//  ShoppingListApp.swift
//  Shopping List
//
//  Created by Gundars Kokins on 10/05/2021.
//

import SwiftUI
import Firebase

class RealtimeDatabase: ObservableObject {
    @Published var ref: DatabaseReference = Database.database(url: "https://shopping-list-6172f-default-rtdb.europe-west1.firebasedatabase.app/").reference()
}

@main
struct ShoppingListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @EnvironmentObject var database: RealtimeDatabase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
