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
    @StateObject private var preferences = Preferences()
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                StartupView()
                    .environmentObject(searchvar)
                    .environmentObject(preferences)
            } else {
                Main()
                    .environmentObject(searchvar)
                    .environmentObject(preferences)
            }
        }
    }
}
