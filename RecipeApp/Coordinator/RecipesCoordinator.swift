//
//  RecipesCoordinator.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/18/25.
//


import SwiftUI

@MainActor
final class RecipesCoordinator: ObservableObject {
    private let service: RecipeServiceProtocol
    private let viewModel: RecipesViewModel
    
    init() {
        service = RecipeService(endpoint: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        )
        viewModel = RecipesViewModel(service: service)
    }
    func start() -> some View {
        RecipesListView(viewModel: viewModel)
    }
}
