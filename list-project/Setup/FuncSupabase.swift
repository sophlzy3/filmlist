//
//  FuncSupabase.swift
//  list-project
//
//  Created by Sophie Liu on 2024-01-07.
//

import Foundation
import Supabase
import SwiftUI


class DatabaseManager {
    static let shared = DatabaseManager()
    private init() {}
    
    let client = SupabaseClient(supabaseURL: URL(string: SupabaseVar.shared.supabaseURL)!, supabaseKey: SupabaseVar.shared.apiPublic)
    
    func addConditions(
        inputQuery: PostgREST.PostgrestFilterBuilder,
        conditions: [(String, String, URLQueryRepresentable)]? = []
    ) async throws -> PostgREST.PostgrestFilterBuilder {
        var query = inputQuery
        
        if let conditions = conditions {
            for condition in conditions {
                let (conditionOperator, field, value) = condition
                
                // eq, neq, gt, gte, lt, lte, like, ilike, is, in, cs, cd, sl, sr, nxl, nxr, adj, ov, fts, plfts, phfts, wfts
                //  like, ilike, is, in, cs, cd, sl, sr, nxl, nxr, adj, ov, fts, plfts, phfts, wfts


                switch conditionOperator {
                case "eq":
                    query = query.eq(field, value: value)
                case "neq":
                    query = query.neq(field, value: value)
                case "gt":
                    query = query.gt(field, value: value)
                case "gte":
                    query = query.gte(field, value: value)
                case "lt":
                    query = query.lt(field, value: value)
                case "lte":
                    query = query.lte(field, value: value)
                case "like":
                    query = query.like(field, value: value)
                case "ilike":
                    query = query.ilike(field, value: value)
                case "is":
                    query = query.is(field, value: value)
                case "in":
                    query = query.in(field, value: value as! [any URLQueryRepresentable])
                default:
                    query = query.eq(field, value: value)
                }
            }
        }
        
        return query
    }
    
//    try await DatabaseManager.shared.createItem(col: "movies", item: movie)
    func createItem<T: Encodable>(database: String, item: T) async throws {
        do {
            try await client.database.from(database).insert(item).execute()
        } catch {
            print("ERROR IN CREATING ITEM =================\n\(error)")
            throw error
        }
    }

//    try await DatabaseManager.shared.fetchItem(database: "movies", ofType: Data_film.self, conditions: [("eq", "id", movieID)])
    func fetchItem<T: Decodable>(
        database: String,
        ofType type: T.Type,
        conditions: [(String, String, URLQueryRepresentable)]? = []
    ) async throws -> [T] 
    {
        do {
            var query = try await client.database.from(database).select()
            query = try await addConditions(inputQuery: query, conditions: conditions)
            let response = try await query.execute()
            
            // Decode the response data into the specified type
            let decoder = JSONDecoder()
            let itemList = try decoder.decode([T].self, from: response.data)
            return itemList
        } catch {
            print("ERROR IN FETCHING ITEM=================\n\(error)")
            throw error
        }
    }
    
    func updateItem<T: Codable, U: URLQueryRepresentable>(database: String, conditions: [(String, String, U)], newValue: [String: T]) async throws {
        do {
            var query = try await client.database.from(database).update(newValue)
            query = try await addConditions(inputQuery: query, conditions: conditions)
            let response = try await query.execute()
        } catch {
            print("ERROR IN UPDATING ITEM=================\n\(error)")
            throw error
        }
    }

    func deleteItems<U: URLQueryRepresentable>(database: String, conditions: [(String, String, U)]) async throws {
        do {
            var query = try await client.database.from(database).delete()
            query = try await addConditions(inputQuery: query, conditions: conditions)
            let response = try await query.execute()
        } catch {
            print("ERROR IN DELETING ITEM=================\n\(error)")
            throw error
        }
    }
}

class SupabaseActions {
    static let supabaseURL = "https://wixystelcgjsbhvkwbin.supabase.co"
    static let apiPublic = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndpeHlzdGVsY2dqc2Jodmt3YmluIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMzODY2NDcsImV4cCI6MjAxODk2MjY0N30.jCZNPtYtWxiTqmOsFcNZ3JLuE4on-eSE7Gtab8EjHxU"
    static let accessToken = "sbp_6aa74ababe7c6fc3953b00176d9490b604b7cd57"
    let client: SupabaseClient
    var selectedFilmDetail: Preview_film?
    var errorMessage: String?
      
    init() {
        client = SupabaseClient(supabaseURL: URL(string: SupabaseVar.shared.supabaseURL)!, supabaseKey: SupabaseVar.shared.apiPublic)
    }
    
    func addMovieDetails(id: Int) async throws {
        do {
            // Fetch movie preview
            print("adding movie details ...")
            let movieResult = try await returnMoviePreview(id)
            let movie = Data_film(
                id: movieResult.id,
                backdrop_path: movieResult.backdrop_path,
                budget: movieResult.budget,
                imdb_id: movieResult.imdb_id,
                overview: movieResult.overview,
                poster_path: movieResult.poster_path,
                original_title: movieResult.original_title,
                release_date: movieResult.release_date,
                status: movieResult.status,
                title: movieResult.title,
                runtime: movieResult.runtime,
                vote_average: movieResult.vote_average)
                        
            try await DatabaseManager.shared.createItem(database: "movies", item: movie)
            
            // add genre
            for genre in movieResult.genres {
                // add company to library if NOT present
                let isGenreInLibrary = try await DatabaseManager.shared.fetchItem(database: "genres", ofType: Preview_genre.self, conditions: [("eq", "id", genre.id)])
//
                if isGenreInLibrary == [] { // empty if not in library
                    try await DatabaseManager.shared.createItem(database: "genres", item: genre)
//                    print("\(genre.name) added to lib")
                } else {
//                    print("\(genre.name) already in lib")
                }
//
                // create relationship instance and add
                let relMovieGenre = Rel_movie_genre(movie_id: movieResult.id, genre_id: genre.id)
                try await DatabaseManager.shared.createItem(database: "movie_genre", item: relMovieGenre)
            }
            
            // add company
            for company in movieResult.production_companies {
                // add company to library if NOT present
                let isCompanyInLibrary = try await DatabaseManager.shared.fetchItem(database: "companies", ofType: Preview_company.self, conditions: [("eq", "id", company.id)])
//
                if isCompanyInLibrary == [] { // empty if not in library
                    try await DatabaseManager.shared.createItem(database: "companies", item: company)
//                    print("\(country.name) added to lib")
                } else {
//                    print("\(country.name) already in lib")
                }
//
                // create relationship instance and add
                let relMovieCompany = Rel_movie_company(movie_id: movieResult.id,company_id: company.id)
                try await DatabaseManager.shared.createItem(database: "movie_company", item: relMovieCompany)
            }
            
            // add country
            for country in movieResult.production_countries {
                // add country to library if NOT present
                let isCountryInLibrary = try await DatabaseManager.shared.fetchItem(database: "countries", ofType: Preview_country.self, conditions: [("eq", "iso_3166_1", country.iso_3166_1)])
                
                if isCountryInLibrary == [] {
                    try await DatabaseManager.shared.createItem(database: "countries", item: country)
//                    print("\(country.name) added to lib")
                } else {
//                    print("\(country.name) already in lib")
                }

//                create relationship instance and add
                let relMovieCountry = Rel_movie_country(movie_id: movieResult.id,country_iso: country.iso_3166_1)
                try await DatabaseManager.shared.createItem(database: "movie_country", item: relMovieCountry)
            }
            
            // add language
            for language in movieResult.spoken_languages {
                // add country to library if NOT present
                let isLanguageInLibrary = try await DatabaseManager.shared.fetchItem(database: "languages", ofType: Preview_language.self, conditions: [("eq", "iso_639_1", language.iso_639_1)])
                
                if isLanguageInLibrary == [] {
                    try await DatabaseManager.shared.createItem(database: "languages", item: language)
                    // print("\(languages.english_name) added to lib")
                } else {
                    // print("\(languages.english_name) already in lib")
                }

                // create relationship instance and add
                let relMovieLanguage = Rel_movie_language(movie_id: movieResult.id, language_iso: language.iso_639_1)
                try await DatabaseManager.shared.createItem(database: "movie_language", item: relMovieLanguage)
            }

//            return 201
            
        } catch {
            print("+++++++++++++++++++++++++++++++++")
            print(error)
            throw error
        }
    }
    
    func addMovieCrewCast(id: Int) async throws -> Int {
        do {
            // add cast
            let peopleResult = try await returnCastDetail(id)
//            print(peopleResult.cast[1])

            for person in peopleResult.cast {
                // add company to library if NOT present

                let isPersonInLibrary = try await DatabaseManager.shared.fetchItem(database: "people", ofType: Data_people.self, conditions: [("eq", "id", person.id)])

                if isPersonInLibrary.isEmpty { // empty if not in library
                    let add_to_people = Data_people(id: person.id, original_name: person.original_name, profile_path: person.profile_path)

                    try await DatabaseManager.shared.createItem(database: "people", item: add_to_people)
//                    print("Added person to library: \(personResponse)")
                }

//                 create relationship instance and add
                let relMovieCast = Rel_movie_person(
                    movie_id: id,
                    person_id: person.id,
                    job: person.job ?? "",
                    character: person.character ?? "",
                    department: person.department ?? ""
                    )
                try await DatabaseManager.shared.createItem(database: "movie_person", item: relMovieCast)
            }
            print("cast finished")

            for person in peopleResult.crew {
//                print(person)

                // add company to library if NOT present
                let isPersonInLibrary = try await DatabaseManager.shared.fetchItem(database: "people", ofType: Data_people.self, conditions: [("eq", "id", person.id)])

                if isPersonInLibrary == [] { // empty if not in library
                    let add_to_people = Data_people(id: person.id, original_name: person.original_name, profile_path: person.profile_path)
                    try await DatabaseManager.shared.createItem(database: "people", item: add_to_people)
                }

                // create relationship instance and add

                let relMovieCrew = Rel_movie_person(
                    movie_id: id,
                    person_id: person.id,
                    job: person.job ?? "",
                    character: person.character ?? "",
//                    known_for_department: person.known_for_department,
                    department: person.department ?? ""
                    )
                try await DatabaseManager.shared.createItem(database: "movie_person", item: relMovieCrew)
            }

            print("crew finished")
            return 201
        } catch {
            throw error
        }
    }
    
    func addMovieNote(movie_id: Int, list_id: Int, note: String) async throws {
        do {
            let movie_list = Rel_movie_list(movie_id: movie_id, list_id: list_id, note: note)
            try await DatabaseManager.shared.createItem(database: "movie_list", item: movie_list)
            
        } catch {
            print(error)
            throw error
        }
    }
    
    func fetchAllMovieList(movie_id: Int) async throws -> ([Data_list], [Rel_movie_list]) {
        do {
            let allLists = try await DatabaseManager.shared.fetchItem(database: "lists", ofType: Data_list.self, conditions: [])

            let allConnections = try await DatabaseManager.shared.fetchItem(database: "movie_list", ofType: Rel_movie_list.self, conditions: [("eq", "movie_id", movie_id)])

            return (allLists, allConnections)
        } catch {
            throw error
        }
    }
    
    func fetchMovie(movie_id: Int) async throws -> [Data_film] {
        do {
            let output = try await DatabaseManager.shared.fetchItem(database: "movies", ofType: Data_film.self, conditions: [("eq", "id", movie_id)])
            return output
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
        
    func changeMovieNote(newNote: String, listID: Int, movieID: Int) async throws {
        do {
            try await DatabaseManager.shared.updateItem(
                database: "movie_list",
                conditions: [("eq", "list_id", listID), ("eq", "movie_id", movieID)],
                newValue: ["note": newNote]
            )
        } catch {
            print("Update failed: \(error)")
        }
    }
    
}

