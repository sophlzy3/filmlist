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
            
            Settings()
                .tag("setting")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
//        .foregroundColor(preferences.accentColor)
    }
}

struct MainBottomBar: View {
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var mainvar: MainVar
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width:.infinity, height:200)
                .foregroundColor(.white)
            HStack{
                Spacer()
                
                Button(action: {
                    mainvar.pageChoice = "search"
                }, label: {
                    VStack{
                        if mainvar.searchActivated {
                            Image(systemName:"magnifyingglass")
                                .foregroundColor(preferences.accentColor)
                            Text("Search")
                                .font(.caption)
                                .foregroundColor(preferences.accentColor)
                        } else {
                            Image(systemName:"magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                })
                
                Spacer()
                
                Button(action: {
                    mainvar.pageChoice = "library"
                }, label: {
                    VStack{
                        if mainvar.libActivated {
                        } else {
                            Image(systemName:"film.stack")
                                .foregroundColor(preferences.accentColor)
                            Text("Library")
                                .font(.caption)
                                .foregroundColor(preferences.accentColor)
                        }
                    }
                })
                
                Spacer()
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
