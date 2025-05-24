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
        "Authorization": "Bearer \(TMDBVar().apiKey)"
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
    guard var components = URLComponents(string: "https://api.themoviedb.org/3/search/movie") else {
        throw URLError(.badURL)
    }
    
    components.queryItems = [
        URLQueryItem(name: "query", value: inputString),
        URLQueryItem(name: "include_adult", value: "false"),
        URLQueryItem(name: "language", value: "en-US"),
        URLQueryItem(name: "page", value: "1"),
    ]
    
    guard let url = components.url else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
        "accept": "application/json",
        "Authorization": "Bearer \(TMDBVar().apiKey)"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)
//    print(String(decoding: data, as: UTF8.self))
    
    let decoder = JSONDecoder()
    return try decoder.decode(MovieSearchResult.self, from: data)
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

func returnRecommendations(_ inputID: Int) async throws -> Film_recs {
    let URLString = "https://api.themoviedb.org/3/movie/\(inputID)/recommendations?language=en-US&page=1"

    guard let encodedURLString = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        throw SearchError.invalidURL
    }
    
    let data = try await requestData(from: encodedURLString)
    let decoder = JSONDecoder()
    do {
        let finalCast = try decoder.decode(Film_recs.self, from: data)
        return finalCast
    } catch {
        throw SearchError.responseDecodingError(error)
    }
}
