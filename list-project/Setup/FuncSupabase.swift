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
    
    //    try await DatabaseManager.shared.insertItem(col: "movies", item: movie)
    func insertItem(
        database: String,
        item: Encodable
    ) async throws {
        do {
            try await client.database.from(database).insert(item).execute()
        } catch {
            print("ERROR IN CREATING ITEM\n=================")
            throw error
        }
    }
    
    func updateItem(
        database: String,
        conditions: [(String, String, URLQueryRepresentable)]? = [],
        newValue: Codable
    ) async throws {
        do {
            var query = try await client.database.from(database).update(newValue)
            query = try await addConditions(inputQuery: query, conditions: conditions)
            try await query.execute()
        } catch {
            print("ERROR IN UPDATING ITEM\n=================")
            throw error
        }
    }
    
    func upsertItem(
        database: String,
        item: Codable,
        onConflict: String?
    ) async throws {
        do {
            //            var query = try await client.database.from(database).upsert(item)
            if onConflict == nil {
                try await client.database.from(database).upsert(item).execute()
            } else {
                try await client.database.from(database).upsert(item, onConflict: onConflict).execute()
            }
        } catch {
            print("ERROR IN UPSERTING ITEM\n=================")
            throw error
        }
    }
    
    //    try await DatabaseManager.shared.fetchItem(database: "movies", ofType: Film_rating.self, conditions: [("eq", "id", movieID)])
    func fetchItem<T: Decodable>(database: String, ofType type: T.Type, conditions: [(String, String, URLQueryRepresentable)]) async throws -> [T] {
        do {
            let items = try await DatabaseManager.shared.fetchItem(
                database: database,
                ofType: type,
                conditions: conditions
            )
            return items
        } catch {
            print("ERROR IN UPSERTING ITEM\n=================\(error)")
            throw error
        }
    }
    
    func deleteItems(
        database: String,
        conditions: [(String, String, URLQueryRepresentable)]? = []
    ) async throws {
        do {
            var query = await client.database.from(database).delete()
            query = try await addConditions(inputQuery: query, conditions: conditions)
            try await query.execute()
        } catch {
            print("ERROR IN DELETING ITEM=================\n\(error)")
            throw error
        }
    }
    
}

class SupabaseActions {
    let client: SupabaseClient
    var selectedFilmDetail: Preview_film?
    var errorMessage: String?
      
    init() {
        client = SupabaseClient(supabaseURL: URL(string: SupabaseVar.shared.supabaseURL)!, supabaseKey: SupabaseVar.shared.apiPublic)
    }
    
    func addMovieDetails(id: Int, filmPreview: ReturnedMovie) async throws {
        do {
            // Fetch movie preview
            print("adding movie details ...")
            let movieResult = try await returnMoviePreview(id)
            let movie = Film_rating(
                id: movieResult.id,
                // backdrop_path: movieResult.backdrop_path,
                // budget: movieResult.budget,
                // imdb_id: movieResult.imdb_id,
                // overview: movieResult.overview,
                // poster_path: movieResult.poster_path,
                // original_title: movieResult.original_title,
                // release_date: movieResult.release_date,
                // status: movieResult.status,
                // title: movieResult.title,
                // runtime: movieResult.runtime,
                // vote_average: movieResult.vote_average,
                cinematography: 0.0,
                editing: 0.0,
                costume_makeup: 0.0,
                lighting: 0.0,
                staging: 0.0,
                setting_props: 0.0,
                narrativeRating: 0.0,
                narrativeComment: "",
                libraryStatus: 0,
                whyWatch: ""
                )
                        
            // try await DatabaseManager.shared.insertItem(database: "movies", item: movie)
            try await DatabaseManager.shared.insertItem(database: "movies_preview", item: filmPreview)
            
            // add genre
            for genre in movieResult.genres {
                // add genre to library if NOT present
                try await DatabaseManager.shared.upsertItem(database: "genres", item: genre, onConflict: "id")

                // create relationship instance and add
                let relMovieGenre = Rel_movie_genre(movie_id: movieResult.id, genre_id: genre.id)
                try await DatabaseManager.shared.insertItem(database: "movie_genre", item: relMovieGenre)
            }
            
            // add company
            for company in movieResult.production_companies {
                // add company to library if NOT present
                try await DatabaseManager.shared.upsertItem(database: "companies", item: company, onConflict: "id")

                // create relationship instance and add
                let relMovieCompany = Rel_movie_company(movie_id: movieResult.id,company_id: company.id)
                try await DatabaseManager.shared.insertItem(database: "movie_company", item: relMovieCompany)
            }
            
            // add country
            for country in movieResult.production_countries {
                // add country to library if NOT present
                try await DatabaseManager.shared.upsertItem(database: "countries", item: country, onConflict: "iso_3166_1")

            //   create relationship instance and add
                let relMovieCountry = Rel_movie_country(movie_id: movieResult.id,country_iso: country.iso_3166_1)
                try await DatabaseManager.shared.insertItem(database: "movie_country", item: relMovieCountry)
            }
            
            // add language
            for language in movieResult.spoken_languages {
                // add country to library if NOT present
                try await DatabaseManager.shared.upsertItem(database: "languages", item: language, onConflict: "iso_639_1")

                // create relationship instance and add
                let relMovieLanguage = Rel_movie_language(movie_id: movieResult.id, language_iso: language.iso_639_1)
                try await DatabaseManager.shared.insertItem(database: "movie_language", item: relMovieLanguage)
            }
            
        } catch {
            print("+++++++++++++++++++++++++++++++++")
            throw error
        }
    }
    
    func addMovieCrewCast(id: Int) async throws -> Int {
        do {
            // add cast
            let peopleResult = try await returnCastDetail(id)
            // print(peopleResult.cast[1])

            for person in peopleResult.cast {
                // add cast to library if NOT present
                let add_to_people = Data_people(id: person.id, original_name: person.original_name, profile_path: person.profile_path, known_for_department: person.known_for_department)
                try await DatabaseManager.shared.upsertItem(database: "people", item: add_to_people, onConflict: "id")
                
                // create relationship instance and add
                let relMovieCast = Rel_movie_person(
                    movie_id: id,
                    person_id: person.id,
                    job: person.job ?? "",
                    character: person.character ?? "",
                    department: person.department ?? ""
                    )
                try await DatabaseManager.shared.insertItem(database: "movie_person", item: relMovieCast)
            }
            print("cast finished")

            for person in peopleResult.crew {
                // add crew to library if NOT present
                let add_to_people = Data_people(id: person.id, original_name: person.original_name, profile_path: person.profile_path, known_for_department: person.known_for_department)
                try await DatabaseManager.shared.upsertItem(database: "people", item: add_to_people, onConflict: "id")

                // create relationship instance and add
                let relMovieCrew = Rel_movie_person(
                    movie_id: id,
                    person_id: person.id,
                    job: person.job ?? "",
                    character: person.character ?? "",
                //    known_for_department: person.known_for_department,
                    department: person.department ?? ""
                    )
                try await DatabaseManager.shared.insertItem(database: "movie_person", item: relMovieCrew)
            }

            print("crew finished")
            return 201
        } catch {
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
    
   func upsertMovieNote(note: String, listID: Int, movieID: Int) async throws {
       do {
           let movie_list = Rel_movie_list(movie_id: movieID, list_id: listID, note: note)
           try await DatabaseManager.shared.upsertItem(database: "movie_list", item: movie_list, onConflict: "movie_id, list_id")
       } catch {
           throw error
       }
   }
    
    func deleteMovie(id: Int) async throws {
    do {
        // 1. Delete relations (child rows) first
        try? await DatabaseManager.shared.deleteItems(database: "movie_person", conditions: [("eq", "movie_id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movie_genre", conditions: [("eq", "movie_id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movie_company", conditions: [("eq", "movie_id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movie_country", conditions: [("eq", "movie_id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movie_language", conditions: [("eq", "movie_id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movie_list", conditions: [("eq", "movie_id", id)])
        // 2. Delete movie from preview and main table
        try? await DatabaseManager.shared.deleteItems(database: "movies_preview", conditions: [("eq", "id", id)])
        try? await DatabaseManager.shared.deleteItems(database: "movies", conditions: [("eq", "id", id)])
            
        print("Successfully deleted id \(id).")
        } catch {
            print("Failed to delete movie with ID \(id): \(error)")
            throw error
        }
}

}

