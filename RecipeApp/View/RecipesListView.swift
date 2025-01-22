//
//  ContentView.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import SwiftUI

struct RecipesListView: View {
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Recipes")
                .toolbar {
                    Button("Resfresh") {
                        viewModel.refresh()
                    }
                }
        }
        .onAppear {
            if case .idle = viewModel.state {
                viewModel.loadRecipes()
            }
        }
    }
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(uiColor: .systemBackground))
            
        case .error(let message):
            VStack(spacing: 12) {
                Text("Error")
                    .font(.headline)
                Text(message)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            
        case .empty:
            VStack {
                Text("No recipes available")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemBackground))
            
        case .loaded(let recipes):
            List(recipes) { recipe in
                RecipeRow(recipe: recipe, viewModel: viewModel)
            }
            .listStyle(.inset)
        }
    }
}
