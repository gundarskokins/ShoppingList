//
//  ShoppingListApp.swift
//  Shopping List
//
//  Created by Gundars Kokins on 10/05/2021.
//

import SwiftUI

@main
struct ShoppingListApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var database = RealtimeDatabase()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(database)
        }
    }
}
