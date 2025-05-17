//
//  LibraryPages.swift
//  list-project
//
//  Created by Sophie Liu on 2025-05-15.
//

import Foundation
import SwiftUI

struct MovieTitlesView: View {
    @State private var movies: [ReturnedMovie] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    MovieResultList(movie_list: movies, source: "library")
                }.padding()
            }
        }
        .onAppear {
            Task {
                if movies.isEmpty {
                    let fetched = try await DatabaseManager.shared.fetchItem(
                        database: "movies_preview",
                        ofType: ReturnedMovie.self,
                        conditions: [],
                    )
                    movies = fetched
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - People View
struct PeopleLibraryView: View {
    @State private var people: [Data_people] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyGridPage(list: people) { person in
                        GridPerson(person: person)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                if people.isEmpty {
                    people = try await DatabaseManager.shared.fetchItem(database: "people", ofType: Data_people.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Countries View
struct CountriesLibraryView: View {
    @State private var countries: [Preview_country] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyGridPage(list: countries) { country in
                        GridCountry(country: country)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                if countries.isEmpty {
                    countries = try await DatabaseManager.shared.fetchItem(database: "countries", ofType: Preview_country.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Companies View
struct CompaniesLibraryView: View {
    @State private var companies: [Preview_company] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyGridPage(list: companies) { company in
                        GridCompany(company: company)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                if companies.isEmpty {
                    companies = try await DatabaseManager.shared.fetchItem(database: "companies", ofType: Preview_company.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Genres View
struct GenresLibraryView: View {
    @State private var genres: [Preview_genre] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyGridPage(list: genres) { genre in
                        GridGenre(genre: genre)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                if genres.isEmpty {
                    genres = try await DatabaseManager.shared.fetchItem(database: "genres", ofType: Preview_genre.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Titles View
struct TitlesLibraryView: View {
    @State private var films: [ReturnedMovie] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    MovieResultList(movie_list: films, source: "library")
                }.padding()
            }
        }
        .onAppear {
            Task {
                if films.isEmpty {
                    films = try await DatabaseManager.shared.fetchItem(database: "movies_preview", ofType: ReturnedMovie.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Lists View
struct ListsLibraryView: View {
    @State private var lists: [Data_list] = []
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyGridPage(list: lists) { list in
                        GridList(list: list)
                    }.padding()
                }
            }
        }
        .onAppear {
            Task {
                if lists.isEmpty {
                    lists = try await DatabaseManager.shared.fetchItem(database: "lists", ofType: Data_list.self, conditions: [])
                    isLoading = false
                }
            }
        }
    }
}

