//
//  LibraryMain.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-20.
//

import SwiftUI

struct LibraryMain: View {
    @State private var isLoading = true
    @State private var path = NavigationPath()
    @State private var items = LibraryItem.allCases

    @State private var people: [Data_people] = []
    @State private var countries: [Preview_country] = []
    @State private var companies: [Preview_company] = []
    @State private var genres: [Preview_genre] = []
    @State private var films: [ReturnedMovie] = []
    @State private var lists: [Data_list] = []

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Library")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 23, bottom: 10, trailing: 10))
                    .background(Color(UIColor.systemGray6))
                
                // Scrollable list
                List {
                    ForEach(Array(items.enumerated()), id: \.element) { index, item in
                        NavigationLink(destination: destinationView(item: item)) {
                            HStack(alignment: .center) {
                                Image(systemName: item.iconName)
                                    .frame(width: 10)
                                Spacer().frame(width: 15)
                                Text(item.rawValue)
                                Spacer().frame(width: .infinity)
                            }
                        }
                    }
                    .onMove(perform: moveItem)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear {
                fetchLibraryData()
            }
            .background(Color(UIColor.systemGray6)) // Background color to match the header
        }
    }



    func fetchLibraryData() {
        Task {
            do {
                DispatchQueue.main.async {
                    isLoading = true
                }
                
                let fetchedCountries = try await DatabaseManager.shared.fetchItem(database: "countries", ofType: Preview_country.self, conditions: [])
                let fetchedCompanies = try await DatabaseManager.shared.fetchItem(database: "companies", ofType: Preview_company.self, conditions: [])
                let fetchedGenres = try await DatabaseManager.shared.fetchItem(database: "genres", ofType: Preview_genre.self, conditions: [])
                let fetchedTitles = try await DatabaseManager.shared.fetchItem(database: "movies_preview", ofType: ReturnedMovie.self, conditions: [])
                let fetchedLists = try await DatabaseManager.shared.fetchItem(database: "lists", ofType: Data_list.self, conditions: [])
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.films = fetchedTitles
                    self.genres = fetchedGenres
                    self.countries = fetchedCountries
                    self.companies = fetchedCompanies
                    self.people = []
                    self.lists = fetchedLists
                }
            } catch {
                print("Failed to fetch films: \(error)")
            }
        }
    }

    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
        
    func destinationView(item: LibraryItem) -> some View {
        switch item {
        case .people:
            do {
                return isLoading
                ? AnyView(ProgressView())
                : AnyView(ScrollView {
                    LazyGridPage(list: self.people) { listObject in
                        GridPerson(person: listObject)
                    }
                }.padding())
            } catch {
                throw error
                return AnyView(destination(thing: "people"))
            }
        case .countries:
            return isLoading
            ? AnyView(ProgressView())
            : AnyView(ScrollView {
                LazyGridPage(list: self.countries) { listObject in
                    GridCountry(country: listObject)
                }
            }.padding())
            
        case .companies:
            return AnyView(destination(thing: "companies"))
        case .genres:
            return AnyView(destination(thing: "genres"))
        case .titles:
            return isLoading
            ? AnyView(ProgressView())
            : AnyView(ScrollView {
                MovieResultList(movie_list: films)
            }.padding())
        
        case .lists:
            return AnyView(destination(thing: "lists"))
        }
    }
}

struct destination: View {
    var thing: String
    
    var body: some View {
        Text(thing)
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        LibraryMain()
            .environmentObject(SearchVar())
//        ContentView()
    }
}
