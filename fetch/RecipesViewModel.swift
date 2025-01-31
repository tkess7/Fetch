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
        do {
            let recipes = try await recipeService.retrieveRecipes(for: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
            self.recipes = recipes.recipes
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
    case undetermined
    case urlError
}
