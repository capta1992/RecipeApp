//
//  Recipe.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import Foundation

struct RecipeListResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Identifiable {
    let id: UUID
    let name: String
    let cuisine: String
    
    let photoURLSmall: URL?
    let photoURLLarge: URL?
    let sourceURL: URL?
    let youtubeURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case name, cuisine, uuid
        case photURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        cuisine = try container.decode(String.self, forKey: .cuisine)
        
        let uuidString = try container.decode(String.self, forKey: .uuid)
        guard let uuidValue = UUID(uuidString: uuidString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .uuid,
                in: container,
                debugDescription: "UUID is invalid"
            )
        }
        id = uuidValue
        
        let smallString = try container.decodeIfPresent(String.self, forKey: .photURLSmall)
        photoURLSmall = smallString.flatMap({ URL(string: $0) })
        
        let largeString = try container.decodeIfPresent(String.self, forKey: .photoURLLarge)
        photoURLLarge = largeString.flatMap({ URL(string: $0) })
        
        let sourceString = try container.decodeIfPresent(String.self, forKey: .sourceURL)
        sourceURL = sourceString.flatMap({ URL(string: $0) })
        
        let youtubeString = try container.decodeIfPresent(String.self, forKey: .youtubeURL)
        youtubeURL = youtubeString.flatMap({ URL(string: $0) })
    }
}
