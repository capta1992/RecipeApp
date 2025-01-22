//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
    func downloadImage(at url: URL) async throws -> Data
}

final class RecipeService: HTTPOperations, RecipeServiceProtocol {
    
    private let endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        let response = try await fetchData(as: RecipeListResponse.self, endpoint: endpoint)
        return response.recipes
    }
    
    func downloadImage(at url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw RecipeError.invalidResponse
        }
        return data
    }
}
