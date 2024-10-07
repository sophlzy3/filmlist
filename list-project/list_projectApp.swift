//
//  list_projectApp.swift
//  list-project
//
//  Created by Sophie Liu on 2023-06-16.
//

import SwiftUI

@main
struct list_projectApp: App {
    @StateObject private var searchvar = SearchVar()
    @StateObject private var preferences = Preferences() // Initialize Preferences here
    
    var body: some Scene {
        WindowGroup {
           Main()
                .environmentObject(searchvar)
                .environmentObject(preferences) // Pass Preferences as an environment object
        }
    }
}
