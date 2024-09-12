//
//  MainStruct.swift
//  list-project
//
//  Created by Sophie Liu on 2023-12-29.
//

import Foundation

struct MovieSearchResult: Codable {
    let page: Int
    let results: [ReturnedMovie]
    let total_pages: Int
    let total_results: Int
    var id: String {UUID().uuidString}
}

// for movie preview wwblock
struct ReturnedMovie: Identifiable, Codable, Hashable, Equatable {
    let id: Int
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let release_date: String?
    let genre_ids: [Int]
    let original_language: String
    let overview: String?
    
    // Hashing function
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(backdrop_path)
        hasher.combine(release_date)
        hasher.combine(genre_ids)
    }
}

// for page preview
struct Preview_film: Codable {
    let backdrop_path: String?
    let budget: Int
    let genres: [Preview_genre]
    let id: Int
    let imdb_id: String
    let overview: String?
    let poster_path: String?
    let production_companies: [Preview_company]
    let production_countries: [Preview_country]
    let original_title: String
    let release_date: String? // hover to show full date
    let spoken_languages: [Preview_language]
    let status: String // eg "Released"
    let title: String
    let runtime: Int
    let vote_average: Float?
}

// for supabase
struct Data_film: Codable {
    let id: Int
    let backdrop_path: String?
    let budget: Int?
    let imdb_id: String?
    let overview: String?
    let poster_path: String?
    let original_title: String
    let release_date: String?
    let status: String? // eg "Released"
    let title: String
    let runtime: Int?
    let vote_average: Float?
}

struct Preview_genre: Codable, Hashable, Equatable {
    let id: Int
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }

    static func == (lhs: Preview_genre, rhs: Preview_genre) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

struct Preview_country: Codable, Equatable {
    let iso_3166_1: String
    let name: String
}
struct Preview_company: Codable, Equatable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}
struct Preview_language: Codable, Equatable {
    let english_name: String
    let iso_639_1: String
    let name: String
}

struct Preview_cast_crew: Codable {
    let cast: [Preview_people]
    let crew: [Preview_people]
}
struct Preview_people: Codable, Identifiable, Equatable {
    let id: Int
    let department: String?
    let job: String?
    let original_name: String
    let profile_path: String?
    let character: String?
    let known_for_department: String?
}

struct Data_people: Codable, Equatable {
    let id: Int
    let original_name: String
    let profile_path: String?
    let known_for_department: String?
}

struct Data_list: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let cover: String
    let imgs: [String]?
    
    func imgsCount() -> Int {
        return imgs?.count ?? 0
    }
}

struct Rel_movie_person: Codable {
    let movie_id: Int
    let person_id: Int
    let job: String?
    let character: String?
    let department: String?
}

struct Rel_movie_country: Codable {
//    let id: Int8
    let movie_id: Int
    let country_iso: String
}

struct Rel_movie_company: Codable {
//    let id: Int8
    let movie_id: Int
    let company_id: Int
}

struct Rel_movie_language: Codable {
//    let id: Int8
    let movie_id: Int
    let language_iso: String
}

struct Rel_movie_genre: Codable {
    let movie_id: Int
    let genre_id: Int
}

struct Rel_country_company: Codable {
    let country_iso: String
    let company_id: Int
}

struct Rel_movie_list: Identifiable, Codable {
    let movie_id: Int
    let list_id: Int // to-watch, watched, 推荐, etc
    let note: String
    
    var id: String {
        return "\(movie_id)-\(list_id)"
    }
}

