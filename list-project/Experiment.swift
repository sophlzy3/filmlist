//
//  experiment.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-06.
//
//
import SwiftUI
import Supabase
import Foundation

//struct MovieSearchResult: Codable {
//    let page: Int
//    let results: [Movie]
//    let total_pages: Int
//    let total_results: Int
//}
//
//struct Movie: Identifiable, Codable {
//    let id: Int
//    let title: String
//    let overview: String?
//    let poster_path: String?
//    let release_date: String?
//}

struct ContentView: View {
    @State private var searchText = ""
    @State private var movies: [ReturnedMovie] = []
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            TextField("Search movies...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    searchMovies()
                }
            
            if isLoading {
                ProgressView()
            } else if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(movies) { movie in
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        if let releaseDate = movie.release_date {
                            Text(releaseDate)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let overview = movie.overview {
                            Text(overview)
                                .font(.body)
                                .lineLimit(3)
                        }
                    }
                }
            }
        }
    }
    
    private func searchMovies() {
        guard !searchText.isEmpty else { return }
        
        Task {
            do {
                isLoading = true
                errorMessage = ""
                
                let url = URL(string: "https://api.themoviedb.org/3/search/movie")!
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
                let queryItems: [URLQueryItem] = [
                    URLQueryItem(name: "query", value: searchText),
                    URLQueryItem(name: "include_adult", value: "false"),
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "page", value: "1"),
                ]
                components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
                
                var request = URLRequest(url: components.url!)
                request.httpMethod = "GET"
                request.timeoutInterval = 10
                request.allHTTPHeaderFields = [
                    "accept": "application/json",
                    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTI4YzAxNDMwNjBmMmIzNTI3NTk4YTlkODE2ZGUyOCIsIm5iZiI6MTY4ODc0OTE5MC40NDcsInN1YiI6IjY0YTg0NDg2YWYyZGE4MDEwY2FkZGRkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.i9HxA6bO3vipXOYYd3IXEf6WkmUD4O3iYHCnKCl46k0"
                ]
                
                let (data, _) = try await URLSession.shared.data(for: request)
                let result = try JSONDecoder().decode(MovieSearchResult.self, from: data)
                
                await MainActor.run {
                    movies = result.results
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



