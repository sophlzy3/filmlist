//
//  SearchDetail.swift
//  list-project
//
//  Created by Sophie Liu on 2023-07-22.
//

import SwiftUI
import UIKit

struct MovieResultList: View {
    @EnvironmentObject var searchvar: SearchVar
    @State private var isSearching: Bool = false
    @State private var isSheetActive = false
    @State private var errorMessage: String = ""
    
    var movie_list: [ReturnedMovie]
    @State private var selectedFilmDetail: Preview_film = Preview_film(backdrop_path: "", budget: 0,genres: [Preview_genre(id:0,name:"Thriller")], id: 0, imdb_id: "tt", overview: "", poster_path: "", production_companies: [Preview_company(id:0,logo_path:"",name:"", origin_country:"US")], production_countries: [Preview_country(iso_3166_1:"us", name:"US")], original_title: "hi", release_date: "yyyy-mm-dd", spoken_languages: [Preview_language(english_name: "English", iso_639_1: "en", name: "English")], status: "Released", title: "", runtime:0, vote_average: 7.784)

    @State private var selectedFilmCast: Preview_cast_crew = Preview_cast_crew(cast: [], crew: [])
    
    var body: some View {
        if searchvar.isSearching {
            ProgressView("Searching...")
        } else if movie_list == [] {
            Text("No results found\n")
                .foregroundColor(.gray)
        } else {
            VStack {
                ForEach(movie_list, id: \.id) { movie in
                    Button(action: {
                        isSheetActive = true
                        MovieDetails(movie.id)
                    }, label: {
                        RowFilm(movie: movie, mode: "block")
                            .aspectRatio(16/9,contentMode:.fit)
                            .padding(EdgeInsets(top: 2.5, leading: 0, bottom: 2.5, trailing: 0))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .sheet(isPresented: $isSheetActive, content: {FilmPage(film: selectedFilmDetail, cast: selectedFilmCast)})
        }
        if !errorMessage.isEmpty {
            Text("Error occurred: \(errorMessage)")
                .foregroundColor(.red)
        }
    }

    //  update info
    private func MovieDetails(_ id: Int) {
        Task {
            do {
                // Call async functions and handle results
                let detailFilm = try await returnMoviePreview(id)
                let detailCast = try await returnCastDetail(id)
                
                DispatchQueue.main.async {
                    self.selectedFilmDetail = detailFilm
                    self.selectedFilmCast = detailCast
                }
            } catch {
                DispatchQueue.main.async {
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
                }
            }
        }
    }
}


struct MovieResultList_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data for preview
        let sampleMovies: [ReturnedMovie] = [
            ReturnedMovie(
                id: 1,
                title: "Inception",
                backdrop_path: "/s3TBrRGB1iav7gFOCNx3H31MoES.jpg",
                poster_path: "/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg",
                release_date: "2010-07-16",
                genre_ids: [28, 12, 878],
                original_language: "en",
                overview: "A skilled thief is offered a chance to erase his past crimes in exchange for infiltrating the mind of a CEO."
            ),
            ReturnedMovie(
                id: 2,
                title: "Interstellar",
                backdrop_path: "/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
                poster_path: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                release_date: "2014-11-05",
                genre_ids: [12, 878],
                original_language: "en",
                overview: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival."
            )
        ]
        
        return MovieResultList(movie_list: sampleMovies)
            .environmentObject(SearchVar())
    }
}

