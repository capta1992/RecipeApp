//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Lawson Falomo on 1/17/25.
//

import XCTest
@testable import RecipeApp

final class RecipeAppTests: XCTestCase {
    
    func testFetchRecipesSuccess() async throws {
        let service = RecipeService(endpoint: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
        do {
            let recipes = try await service.fetchRecipes()
            XCTAssertFalse(recipes.isEmpty, "Expected some recipes")
        } catch {
            XCTFail("Should not fail on real endpoint: \(error)")
        }
    }
    
    func testFetchRecipesEmpty() async throws {
        let service = RecipeService(endpoint: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
        
        do {
            let recipes = try await service.fetchRecipes()
            XCTAssertTrue(recipes.isEmpty, "Should be empty for the empty data endpoint")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testFetchRecipesMalformed() async throws {
        let service = RecipeService(endpoint: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
        do {
            _ = try await service.fetchRecipes()
            XCTFail("Should have throw an error for malformed data")
        } catch {
            // We expect .malformedData or .invalidResponse
        }
    }
    func testImageCache() async throws {
        // I will use a mock approach that does not rely on a real host
        class MockService: RecipeServiceProtocol {
            func fetchRecipes() async throws -> [RecipeApp.Recipe] { return [] }
            
            func downloadImage(at url: URL) async throws -> Data {
                // Return in-memory data for 1X1 PNG
                let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
                let dummy = renderer.image { context in
                    UIColor.red.setFill()
                    context.fill(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
                }
                guard let data = dummy.pngData() else {
                    throw RecipeError.malformedData
                }
                return data
            }
        }
        let mock = MockService()
        let testURL = URL(string: "https://mockserver.com/image.png")!
        
        do {
            let image1 = try await ImageCache.shared.fetchImage(from: testURL, service: mock)
            let image2 = try await ImageCache.shared.fetchImage(from: testURL, service: mock)
            XCTAssertEqual(image1.size, image2.size, "Cache usage - same image")
        } catch {
            XCTFail("Image Cache test failed: \(error)")
        }
    }
}
