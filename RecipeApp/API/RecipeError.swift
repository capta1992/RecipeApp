//
//  RecipeError.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import Foundation

enum RecipeError: Error {
    case invalidURL
    case invalidResponse
    case malformedData
    case diskCacheFailed
    case other(Error)
}
