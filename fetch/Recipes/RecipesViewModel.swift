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
    var recipeViewState: RecipeViewState = .undetermined
    
    private let recipeService: RecipeRetrieving
    
    private let recipeURLs = [
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json",
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json",
        "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
    ]
    
    private var recipeURLIndex = 0
    
    init(recipeService: RecipeRetrieving) {
        self.recipeService = recipeService
    }
    
    func initializeRecipes() async {
        await fetchRecipeData()
    }
    
    func refreshRecipes() async {
        recipeViewState = .undetermined
        recipes = []
        
        await fetchRecipeData()
    }
    
    func fetchRecipeData() async {
        // Intentional 3 second delay for demo purposes.
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Cycle through recipeURLs when retrieving data. The order will be
        // valid recipes, malformed, then empty.
        let recipeURL = recipeURLs[recipeURLIndex]
        recipeURLIndex = (recipeURLIndex + 1) % recipeURLs.count
        
        do {
            let recipes = try await recipeService.retrieveRecipes(for: recipeURL)
            self.recipes = recipes.recipes
            recipeViewState = .success
        } catch _ as DecodingError {
            recipes = []
            recipeViewState = .decodingError
        } catch RecipeServiceError.invalidURL {
            recipes = []
            recipeViewState = .urlError
        } catch {
            recipes = []
            recipeViewState = .generalError
        }
    }
}

enum RecipeViewState {
    case decodingError
    case generalError
    case success
    case undetermined
    case urlError
}
