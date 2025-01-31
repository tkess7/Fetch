//
//  RecipeListView.swift
//  fetch
//
//  Created by Travis Kessinger on 1/30/25.
//

import SwiftUI

struct RecipeListView: View {
    @State private var recipesViewModel = RecipesViewModel()
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
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(recipeSearchResult) { recipe in
                        RecipeRowView(cuisine: recipe.cuisine, name: recipe.name, smallPhotoURL: recipe.smallPhotoURL)
                    }
                }
                .padding(.horizontal)
            }
            .overlay {
                if recipeSearchResult.isEmpty {
                    ContentUnavailableView.search
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
