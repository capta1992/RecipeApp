//
//  RecipeRow.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/22/25.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipesViewModel
    
    @State private var image: UIImage?
    
    var body: some View {
        HStack(spacing: 16) {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .cornerRadius(8)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 64, height: 64)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            Task {
                if image == nil {
                    image = await viewModel.fetchImage(for: recipe)
                }
            }
        }
        .background(Color.white.opacity(0.0001))
    }
}
