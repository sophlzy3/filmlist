//
//  Main.swift
//  list-project
//
//  Created by Sophie Liu on 2023-09-24.
//

import SwiftUI

struct Main: View {
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var searchvar: SearchVar
    @State private var selectedTab = "search"

    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryMain()
                .tag("library")
                .tabItem {
                    Label("Library", systemImage: "film.stack")
                }
            
            SearchView()
                .tag("search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .environmentObject(searchvar)
                .environmentObject(preferences)
//                .onAppear {
//                    searchvar.isSearchFocused = true
//                }8
                .onTapGesture {
                    if selectedTab == "search" {
                        searchvar.isSearchFocused = true
//                        print(searchvar.isSearchFocused)
                    }
                }
            
            Settings()
                .tag("setting")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
            .environmentObject(SearchVar())
            .environmentObject(Preferences())
    }
}
