//
//  RecipeRetrieving.swift
//  fetch
//
//  Created by Travis Kessinger on 1/31/25.
//

import Foundation

protocol RecipeRetrieving {
    func retrieveRecipes(for url: String) async throws -> Recipes
}

struct RecipeServices: RecipeRetrieving {
    func retrieveRecipes(for stringURL: String) async throws -> Recipes {
        guard let url = URL(string: stringURL) else {
            throw RecipeServiceError.invalidURL
        }
        
        let result = try await URLSession.shared.data(from: url)
        let recipes = try JSONDecoder().decode(Recipes.self, from: result.0)
        return recipes
    }
}

enum RecipeServiceError: Error {
    case invalidURL
}
