//
//  RecipesViewModel.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/18/25.
//

import SwiftUI
import UIKit

@MainActor
class RecipesViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let service: RecipeServiceProtocol
    
    init(service: RecipeServiceProtocol) {
        self.service = service
    }
    
    func loadRecipes() {
        state = .loading
        Task {
            do {
                let recipes = try await service.fetchRecipes()
                if recipes.isEmpty {
                    state = .empty
                } else {
                    state = .loaded(recipes)
                }
            } catch let e as RecipeError {
                switch e {
                case .malformedData:
                    state = .error("Recipes are malformed.")
                default:
                    state = .error(e.localizedDescription)
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func refresh() {
        loadRecipes()
    }
    
    func fetchImage(for recipe: Recipe) async -> UIImage? {
        let url = recipe.photoURLSmall ?? recipe.photoURLLarge
        guard let validURL = url else {
            return nil
        }
        do {
            let image = try await ImageCache.shared.fetchImage(from: validURL, service: service)
            return image
        } catch {
            return nil
        }
    }
}
