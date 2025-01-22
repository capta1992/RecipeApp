//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Lawson Falomo on 1/17/25.
//

import SwiftUI

@main
struct RecipeAppApp: App {
    @StateObject private var coordinator = RecipesCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
