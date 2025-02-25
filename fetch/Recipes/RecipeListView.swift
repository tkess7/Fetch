//
//  RecipeListView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import SwiftUI

struct RecipeListView: View {
    @State private var recipesViewModel = RecipesViewModel(recipeService: RecipeServices())
    @State private var searchInput = ""
    
    var recipeSearchResult: [Recipe] {
        if searchInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return recipesViewModel.recipes
        } else {
            return recipesViewModel.recipes.filter { recipe in
                return recipe.cuisine.contains(searchInput)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(recipeSearchResult) { recipe in
                RecipeRowView(cuisine: recipe.cuisine, largePhotoURL: recipe.largePhotoURL, name: recipe.name, smallPhotoURL: recipe.smallPhotoURL, uuid: recipe.uuid)
            }
            .tint(.gray)
            .overlay {
                switch recipesViewModel.recipeViewState {
                case .decodingError:
                    RecipesDecodingErrorView()
                case .generalError, .urlError:
                    RecipesGeneralErrorView()
                case .success where recipesViewModel.recipes.isEmpty:
                    NoRecipesView()
                case .success where recipeSearchResult.isEmpty:
                    ContentUnavailableView.search
                case .undetermined:
                    ProgressView()
                case .success:
                    EmptyView()
                }
            }
            .task {
                await recipesViewModel.initializeRecipes()
            }
            .refreshable {
                await recipesViewModel.refreshRecipes()
            }
            .navigationTitle("Recipes")
        }
        .searchable(text: $searchInput, prompt: "Search recipes by cuisine")
    }
}

#Preview {
    RecipeListView()
}
