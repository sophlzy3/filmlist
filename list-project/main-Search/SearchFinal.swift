//
//  SearchView.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-17.
//

import SwiftUI
import Foundation

#if os(iOS)
import UIKit
#endif

struct SearchView: View {
    @EnvironmentObject var searchvar: SearchVar
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        ScrollView {
            VStack {
                SearchBar()
                SearchLocation()
                    .frame(maxWidth: .infinity, minHeight: 40)
                SearchOption()
                    .environmentObject(searchvar)
                    .environmentObject(preferences)
                
                if searchvar.ButtonPosition {
                    SearchLibrary()
                } else{
                    SearchTMDB()
                }
            }
            .padding(EdgeInsets(top:0, leading: 26, bottom: 0, trailing: 26))
            Spacer()
        }
    }
}

struct SearchBar: View {
    @EnvironmentObject var searchvar: SearchVar
    @State private var errorMessage: String = ""
    @FocusState private var isSearchFocused: Bool
    
    private var systemGray5: Color {
        #if os(iOS)
        return Color(UIColor.systemGray5)
        #else
        return Color(NSColor.systemGray)
        #endif
    }
    
    private var systemGray: Color {
        #if os(iOS)
        return Color(UIColor.systemGray)
        #else
        return Color(NSColor.systemGray)
        #endif
    }
    
    var body: some View {
        HStack (alignment:.center) {
            ZStack (alignment: .leading){
                RoundedRectangle(cornerRadius: 10)
                    .fill(systemGray5)
                HStack{
                    Image(systemName:"magnifyingglass")
                        .padding(EdgeInsets(top:0, leading: 10, bottom: 0, trailing: 0))
                    
                    if searchvar.ButtonPosition == false {
                        TextField("Search TMDB Database", text: $searchvar.SearchText)
                            .onChange(of: searchvar.SearchText) { newValue in
                                searchvar.SearchText = newValue
                            }
                            .onAppear {
                                isSearchFocused = searchvar.isSearchFocused
                            }
                            .onChange(of: isSearchFocused) { newValue in
                                searchvar.isSearchFocused = newValue
                            }
                            .onChange(of: searchvar.isSearchFocused) { newValue in
                                isSearchFocused = newValue
                            }
                            .focused($isSearchFocused)
                            .onSubmit {
                                print("searching...")
                                searchMovie()
                            }
                    } else {
                        TextField("Search in Library",text: $searchvar.SearchText)
                    }
                    
                    Button(action: {
                        searchvar.SearchText = ""
                    }) {
                        Image(systemName:"xmark.circle.fill")
                            .foregroundColor(systemGray)
                            .padding(EdgeInsets(top:0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
            }
            .frame(width:.infinity,height:40)
            
            Button(action: {
                print("DEBUG: Test button pressed - \(Date())")
                searchMovie()
            }) {
                Text("Test Search")
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Text("Cancel")
                .padding(EdgeInsets(top:10, leading: 0, bottom: 10, trailing: 0))
                .onTapGesture {
                    isSearchFocused = false // Collapse the keyboard
                }
        }
    }
    
    private func searchMovie() {
        print("DEBUG: searchMovie() called")
        Task {
            print("DEBUG: Inside Task")
            do {
                print("DEBUG: Inside do block")
                DispatchQueue.main.async {
                    print("DEBUG: Setting isSearching to true")
                    searchvar.isSearching = true
                }
                
                print("DEBUG: About to call returnMovieSearch")
                let movieResults = try await returnMovieSearch(searchvar.SearchText)
                print("DEBUG: Got movie results")
                
                DispatchQueue.main.async {
                    print("DEBUG: Updating search results")
                    self.searchvar.searchResults = movieResults
                    self.errorMessage = self.searchvar.searchResults.results.isEmpty ? "No results found" : ""
                    self.searchvar.isSearching = false
                }
            } catch {
                print("DEBUG: Caught error: \(error)")
                DispatchQueue.main.async {
                    self.searchvar.isSearching = false
                    switch error {
                    case SearchError.invalidURL:
                        self.errorMessage = "Invalid URL"
                    case SearchError.networkError(let networkError):
                        self.errorMessage = "Network Error: \(networkError.localizedDescription)"
                    case SearchError.invalidResponse:
                        self.errorMessage = "Invalid Response"
                    case SearchError.responseDecodingError(let decodingError):
                        self.errorMessage = "Response Decoding Error: \(decodingError.localizedDescription)"
                    case SearchError.emptyResponse:
                        self.errorMessage = "Empty Response: No data returned"
                    default:
                        self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    }
                    self.searchvar.searchResults = MovieSearchResult(page: 0, results: [], total_pages: 0, total_results: 0)
                }
            }
        }
    }
}

struct SearchLocation: View {
    @EnvironmentObject var searchvar: SearchVar
    
    private var systemGray5: Color {
        #if os(iOS)
        return Color(UIColor.systemGray5)
        #else
        return Color(NSColor.systemGray)
        #endif
    }
    
    private var systemGray6: Color {
        #if os(iOS)
        return Color(UIColor.systemGray6)
        #else
        return Color(NSColor.systemGray)
        #endif
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment:.leading){
                Button(action: {
                    withAnimation (.easeInOut(duration: 0.6)){
                        searchvar.ButtonPosition.toggle()
                    }
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(systemGray5)
                        .frame(width: .infinity, height: 40)
                }
                
                HStack{
                    if searchvar.ButtonPosition {
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .fill(systemGray6)
                        .frame(width:geometry.size.width * 0.5)
                        .padding(5)
                }
                
                HStack{
                    HStack{
                        Spacer()
                        Text("TMDB")
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("Library")
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SearchOption: View {
    @EnvironmentObject var searchvar: SearchVar
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack{                
                HStack (spacing:0){
                    Button (action: {
                        searchvar.optionChoice = "Title"
                    }){
                        ZStack{
                            if searchvar.optionChoice == "Title" {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(preferences.accentColor)
                                Text("Title")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }else{
                                Text("Title")
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }
                        }
                    }
                    
                    Button (action:{
                        searchvar.optionChoice = "Crew"
                    }){
                        ZStack{
                            if searchvar.optionChoice == "Crew" {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(preferences.accentColor)
                                Text("Crew")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }else{
                                Text("Crew")
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }
                        }
                    }
                    
                    Button (action:{
                        searchvar.optionChoice = "Companies"
                    }){
                        ZStack{
                            if searchvar.optionChoice == "Companies" {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(preferences.accentColor)
                                Text("Companies")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }else{
                                Text("Companies")
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }
                        }
                    }
                    
                    Button (action:{
                        searchvar.optionChoice = "Awards"
                    }){
                        ZStack{
                            if searchvar.optionChoice == "Awards" {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(preferences.accentColor)
                                Text("Awards")
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }else{
                                Text("Awards")
                                    .foregroundColor(.black)
                                    .padding(EdgeInsets(top:5, leading: 10, bottom: 5, trailing: 10))
                            }
                        }
                    }
                }
                .padding(3)
                .frame(width:.infinity,height:40)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct SearchTMDB: View {
    @EnvironmentObject var searchvar: SearchVar
    
    var body: some View {
        if searchvar.optionChoice == "Title" {
            MovieResultList(movie_list: searchvar.searchResults.results)
                .environmentObject(searchvar)
        } else {
            Text("SEARCHING IN TMDB")
        }
    }
}

struct SearchLibrary: View {
    var body: some View {
        Text("SEARCHING IN LIBRARY")
    }
}

//---------------
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
           .environmentObject(SearchVar())
           .environmentObject(Preferences())
    }
}

