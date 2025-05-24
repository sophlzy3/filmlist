//
//  RowFilmBlock.swift
//  list-project
//
//  Created by Sophie Liu on 2024-07-23.
//

import SwiftUI

struct RowFilm: View {
    var movie: ReturnedMovie
    var mode: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if mode == "block" {
                    FilmBlock(film: movie)
                } else if mode == "list" {
                    FilmList(film: movie)
                }
                ButtonRow(movie: movie)
                    .frame(maxHeight:.infinity)
            }
        }
    }
}


struct FilmBlock: View {
    @State private var originalFrameSize: CGSize?
    var film: ReturnedMovie
    var descriptionString: String {
        let releaseYear = film.release_date?.prefix(4) ?? "Date Unknown"
        
        var genreString: String {
            let genreNames = film.genre_ids.compactMap { genreIDs[$0] }
            
            if genreNames.isEmpty {
                return "No genre"
            } else if genreNames.count <= 2 {
                return genreNames.joined(separator: "/")
            } else {
                return genreNames.prefix(2).joined(separator: "/")
            }
        }
        
        // Define englishName outside the conditional to use it later
        var englishName = "Unknown"
        
        // Assuming languageIDs is defined as [String: [String: String]]
        if let languageInfo = languageIDs[film.original_language] {
            englishName = languageInfo["english_name"] ?? "Unknown"
        }
        
        return "\(releaseYear) • \(genreString) • \(englishName)"
    }

    var body: some View {
        GeometryReader { geometry in
            let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.backdrop_path ?? ""))!
            ZStack (alignment: .bottomLeading){
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.horizontal)
                            .clipped()
                            .foregroundColor(.secondary)
                    case .failure:
                        Color(UIColor.systemGray3)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(Color.black.opacity(0.25))
                
                VStack (alignment:.leading){
                    Text(film.title)
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(width:.infinity)
                    Spacer()
                        .frame(height:10)
                    
                    Text(descriptionString)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size:15))
                      
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 40))
            }
        }
    }
}

struct RecBlock: View {
    var film: Film_recs
    var body: some View {
        let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.backdrop_path ?? ""))!
            ZStack (alignment: .bottomLeading){
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.horizontal)
                            .clipped()
                            .foregroundColor(.secondary)
                    case .failure:
                        Color(UIColor.systemGray3)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Rectangle()
                    .fill(Color.black.opacity(0.25))
                
                VStack (alignment:.leading){
                    Text(film.title)
                        .foregroundColor(.white)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(width:.infinity)
                    Spacer()
                        .frame(height:10)
                    
                    Text(film.release_date?.prefix(4) ?? "Date Unknown")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size:15))
                      
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 20, trailing: 40))
            }
    }
}

struct FilmList: View {
    @State private var originalFrameSize: CGSize?
    var film: ReturnedMovie
    var descriptionString: String {
        let releaseYear = film.release_date?.prefix(4) ?? "Date Unknown"
        
        var genreString: String {
            let genreNames = film.genre_ids.compactMap { genreIDs[$0] }
            
            if genreNames.isEmpty {
                return "No genre"
            } else if genreNames.count <= 2 {
                return genreNames.joined(separator: "/")
            } else {
                return genreNames.prefix(2).joined(separator: "/")
            }
        }
        
        // Define englishName outside the conditional to use it later
        var englishName = "Unknown"
        
        // Assuming languageIDs is defined as [String: [String: String]]
        if let languageInfo = languageIDs[film.original_language] {
            englishName = languageInfo["english_name"] ?? "Unknown"
        }
        
//        return "\(releaseYear) • \(genreString) • \(englishName)"
        return "\(releaseYear) • \(genreString)"
    }

    var body: some View {
        GeometryReader { geometry in
            let imageURL = URL(string: "https://image.tmdb.org/t/p/original/" + (film.poster_path ?? ""))!
                    
            HStack {
                ZStack {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Display a progress indicator while loading
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(27.0/40.0, contentMode: .fit) // Set aspect ratio
                                .clipped()
                                .frame(height: geometry.size.height)
                        case .failure:
                            Color(UIColor.systemGray3) // Show a gray color on failure
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.25))
                        .frame(width: geometry.size.height/40*27, height: geometry.size.height)
//                        .frame(width: 370, height: 250)
                }
                
                VStack (alignment:.leading){
                    Text(film.title)
                        .font(.system(size: 23))
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(width:.infinity)
                    Spacer()
                        .frame(height:10)
                    
                    Text(descriptionString)
                        .fontWeight(.bold)
                        .font(.system(size:15))
                    Spacer()
                    Text(film.overview ?? "")
                        .font(.system(size:15))
                        .foregroundColor(Color.gray)
                      
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 40))

            }
        }
    }
}


struct BlockFilmRow_Preview: PreviewProvider {
    static var previews: some View {
        let dummyFilm = ReturnedMovie(id: 136, title: "Portrait of a Lady on Fire", backdrop_path: "/foFq1RZWQIgFuCQ0nyYccywjFyX.jpg", poster_path: "/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg", release_date: "2019-06-17", genre_ids: [18,10749], original_language: "fr", overview: "On an isolated island in Brittany at the end of the eighteenth century, a female painter is obliged to paint a wedding portrait of a young woman.")
        VStack {
            RowFilm(movie: dummyFilm, mode: "block")
                .aspectRatio(16/9, contentMode: .fit)
            Spacer()
                .frame(height: 40)
            RowFilm(movie: dummyFilm, mode: "list")
                .aspectRatio(16/9, contentMode: .fit)
        }
    }
}

