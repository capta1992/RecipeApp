//
//  HTTPOperations.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import Foundation

protocol HTTPOperations {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String, method: HTTPMethods, body: Data?, headers: [String: String]?) async throws -> T
}

extension HTTPOperations {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String, method: HTTPMethods = .GET, body: Data? = nil, headers: [String: String]? = nil) async throws -> T {
        guard let url = URL(string: endpoint) else {
            throw RecipeError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body
        }
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw RecipeError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw RecipeError.malformedData
        }
    }
}
