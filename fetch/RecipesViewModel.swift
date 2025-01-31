//
//  RecipesViewModel.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import Foundation
import Observation

@Observable class RecipesViewModel {
    var recipes: [Recipe] = []
    var errorFetchingRecipeData = false
    
    func initializeRecipes() async {
        await fetchRecipeData()
    }
    
    func refreshRecipes() async {
        recipes = []
        
        await fetchRecipeData()
    }
    
    func fetchRecipeData() async {
        do {
            let result = try await URLSession.shared.data(from: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!)
            let recipes = try JSONDecoder().decode(Recipes.self, from: result.0)
            self.recipes = recipes.recipes
        } catch {
            recipes = []
            errorFetchingRecipeData = true
        }
    }
}
