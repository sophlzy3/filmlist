//
//  MainError.swift
//  list-project
//
//  Created by Sophie Liu on 2024-01-03.
//

import Foundation

enum SearchError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case emptyResponse
    case responseDecodingError(Error)
    case invalidData
}



enum LibraryError: Error {
    case failedToAdd(Error)
}

enum CompileError: Error {
    case compilationError(Error)
}
