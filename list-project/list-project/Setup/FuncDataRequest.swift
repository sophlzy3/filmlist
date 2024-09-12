//
//  FuncReturn.swift
//  list-project
//
//  Created by Sophie Liu on 2024-01-07.
//

import Foundation


func requestData(from url: String) async throws -> Data {
    guard let requestURL = URL(string: url) else {
        throw SearchError.invalidURL
    }
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTI4YzAxNDMwNjBmMmIzNTI3NTk4YTlkODE2ZGUyOCIsInN1YiI6IjY0YTg0NDg2YWYyZGE4MDEwY2FkZGRkNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2l2A3yt7lWpgt0fGmmUZnbhcCn6wN-vkxd51yGys73M"
    ]
    var request = URLRequest(url: requestURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw SearchError.invalidResponse
    }
    
    guard httpResponse.statusCode == 200 else {
        throw SearchError.invalidResponse
    }
    
    return data
}

func returnMovieSearch(_ inputString: String) async throws -> MovieSearchResult {
    let urlString = "https://api.themoviedb.org/3/search/movie?query=\(inputString)"
    guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        throw SearchError.invalidURL
    }
    
    let movieData = try await requestData(from: encodedURLString)
    let decoder = JSONDecoder()
    let searchResponse = try decoder.decode(MovieSearchResult.self, from: movieData)
    
    return searchResponse
}

func returnMoviePreview(_ movieID: Int) async throws -> Preview_film {
    let movieURLString = "https://api.themoviedb.org/3/movie/\(movieID)"
    
    do {
        let movieData = try await requestData(from: movieURLString)
        let decoder = JSONDecoder()
        let finalFilm = try decoder.decode(Preview_film.self, from: movieData)
        return finalFilm
    } catch {
        throw error
    }
}

func returnCastDetail(_ inputID: Int) async throws -> Preview_cast_crew {
    let castURLString = "https://api.themoviedb.org/3/movie/\(inputID)/credits"
    guard let encodedURLString = castURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        throw SearchError.invalidURL
    }
    
    let castData = try await requestData(from: encodedURLString)
    let decoder = JSONDecoder()
    do {
        let finalCast = try decoder.decode(Preview_cast_crew.self, from: castData)
        return finalCast
    } catch {
        throw SearchError.responseDecodingError(error)
    }
}

//"adult": false,
//"gender": 1,
//"id": 2227,
//"known_for_department": "Acting",
//"name": "Nicole Kidman",
//"original_name": "Nicole Kidman",
//"popularity": 63.721,
//"profile_path": "/m56BJJsW3uynaZDwtFCFeoDgH5o.jpg",
//"cast_id": 3,
//"character": "Grace Margaret Mulligan",
//"credit_id": "52fe4251c3a36847f8014c93",
//"order": 0


//"adult": false,
//"gender": 2,
//"id": 42,
//"known_for_department": "Directing",
//"name": "Lars von Trier",
//"original_name": "Lars von Trier",
//"popularity": 16.416,
//"profile_path": "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
//"credit_id": "52fe4251c3a36847f8014c8f",
//"department": "Writing",
//"job": "Screenplay"

//"adult": false,
//"gender": 2,
//"id": 42,
//"known_for_department": "Directing",
//"name": "Lars von Trier",
//"original_name": "Lars von Trier",
//"popularity": 16.416,
//"profile_path": "/vyLqx52Fj5E5wN6gqJtqOyWIfa6.jpg",
//"credit_id": "52fe4251c3a36847f8014c89",
//"department": "Directing",
//"job": "Director"
