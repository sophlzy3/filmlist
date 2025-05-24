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
import PostgREST
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
                                print("Searching in TMDB...")
                                searchMovie()
                            }
                    } else {
                        TextField("Search in Library",text: $searchvar.SearchText)
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
                                print("Searching \(searchvar.SearchText) in Library...")
                                searchLibrary()
                            }
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
            
            Text("Cancel")
                .padding(EdgeInsets(top:10, leading: 0, bottom: 10, trailing: 0))
                .onTapGesture {
                    isSearchFocused = false // Collapse the keyboard
                }
        }
    }
    
    private func searchMovie() {
        Task {
            do {
                DispatchQueue.main.async {
                    searchvar.isSearching = true
                }
                
                // URL encode the search text
                guard let encodedSearchText = searchvar.SearchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid search text"
                        self.searchvar.isSearching = false
                    }
                    return
                }
                
                let movieResults = try await returnMovieSearch(encodedSearchText)
                
                DispatchQueue.main.async {
                    self.searchvar.searchResults = movieResults
                    self.errorMessage = self.searchvar.searchResults.results.isEmpty ? "No results found" : ""
                    self.searchvar.isSearching = false
                }
            } catch {
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
    
    private func searchLibrary() {
        Task {
            do {
                DispatchQueue.main.async {
                    searchvar.isSearching = true
                }
                
                // Search in movies_preview table
                let conditions: [(String, String, URLQueryRepresentable)] = [
                    ("title", "ilike", "\(searchvar.SearchText)")
                ]
                print(conditions)
                
                let movieResults = try await DatabaseManager.shared.fetchItem(
                    database: "movies_preview",
                    ofType: ReturnedMovie.self,
                    conditions: conditions
                )
                
                
                DispatchQueue.main.async {
                    self.searchvar.searchResults = MovieSearchResult(
                        page: 1,
                        results: movieResults,
                        total_pages: 1,
                        total_results: movieResults.count
                    )
                    self.errorMessage = movieResults.isEmpty ? "No results found" : ""
                    self.searchvar.isSearching = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.searchvar.isSearching = false
                    self.errorMessage = "Error searching library: \(error.localizedDescription)"
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
    
    let options = ["Title", "TV", "People", "Companies"]
    
    var body: some View {
        ScrollView(.horizontal) {
            ZStack {                
                HStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            searchvar.optionChoice = option
                        }) {
                            ZStack {
                                if searchvar.optionChoice == option {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(preferences.accentColor)
                                    Text(option)
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                } else {
                                    Text(option)
                                        .foregroundColor(.black)
                                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                }
                            }
                        }
                    }
                }
                .padding(3)
                .frame(width: .infinity, height: 40)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct SearchTMDB: View {
    @EnvironmentObject var searchvar: SearchVar
    
    var body: some View {
        if searchvar.optionChoice == "Title" {
            MovieResultList(movie_list: searchvar.searchResults.results, source: "search")
                .environmentObject(searchvar)
        } else if searchvar.optionChoice == "TV" {
            Text("SEARCHING IN TMDB")
        } else if searchvar.optionChoice == "People" {
            Text("SEARCHING IN TMDB")
        } else if searchvar.optionChoice == "Companies" {
            Text("SEARCHING IN TMDB")
        }
    }
}

struct SearchLibrary: View {
    @EnvironmentObject var searchvar: SearchVar
    @State private var movies: [ReturnedMovie] = []
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                MovieResultList(movie_list: movies, source: "library")
            }
        }
        .onAppear {
            Task {
                if movies.isEmpty {
                    do {
                        let conditions: [(String, String, URLQueryRepresentable)] = [
                            ("title", "ilike", "%\(searchvar.SearchText)%")
                        ]
                        
                        let fetched = try await DatabaseManager.shared.fetchItem(
                            database: "movies_preview",
                            ofType: ReturnedMovie.self,
                            conditions: conditions
                        )
                        movies = fetched
                        isLoading = false
                    } catch {
                        print("Error fetching movies: \(error)")
                        isLoading = false
                    }
                }
            }
        }
        .onChange(of: searchvar.SearchText) { newValue in
            Task {
                isLoading = true
                do {
                    let conditions: [(String, String, URLQueryRepresentable)] = [
                        ("title", "ilike", "%\(newValue)%")
                    ]
                    
                    let fetched = try await DatabaseManager.shared.fetchItem(
                        database: "movies_preview",
                        ofType: ReturnedMovie.self,
                        conditions: conditions
                    )
                    movies = fetched
                    isLoading = false
                } catch {
                    print("Error fetching movies: \(error)")
                    isLoading = false
                }
            }
        }
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

