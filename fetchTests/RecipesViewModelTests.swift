//
//  RecipesViewModelTests.swift
//  fetchTests
//
//  Created by Travis Kessinger on 1/31/25.
//

import XCTest
@testable import fetch

final class RecipesViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchRecipesInitializeSuccess() async throws {
        let mockService = MockRecipeServiceSuccess()
        let viewModel = RecipesViewModel(recipeService: mockService)
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        
        await viewModel.initializeRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 1)
    }
    
    func testFetchRecipesRefreshSuccess() async throws {
        let mockService = MockRecipeServiceSuccess()
        let viewModel = RecipesViewModel(recipeService: mockService)
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        
        await viewModel.refreshRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 1)
    }
    
    func testFetchRecipesNetworkFailure() async throws {
        let mockService = MockRecipeServiceNetworkFailure()
        let viewModel = RecipesViewModel(recipeService: mockService)
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        
        await viewModel.initializeRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertTrue(viewModel.recipeViewState == .generalError)
    }
    
    func testFetchRecipesDecodingFailure() async throws {
        let mockService = MockRecipeServiceDecodingFailure()
        let viewModel = RecipesViewModel(recipeService: mockService)
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        
        await viewModel.initializeRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertTrue(viewModel.recipeViewState == .decodingError)
    }
    
    func testFetchRecipesURLFailure() async throws {
        let mockService = MockRecipeServiceURLFailure()
        let viewModel = RecipesViewModel(recipeService: mockService)
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        
        await viewModel.initializeRecipes()
        
        XCTAssertEqual(viewModel.recipes.count, 0)
        XCTAssertTrue(viewModel.recipeViewState == .urlError)
    }
}

class MockRecipeServiceSuccess: RecipeRetrieving {
    func retrieveRecipes(for url: String) async throws -> Recipes {
        let recipe = Recipe(cuisine: "Malaysian",
                            name: "Apam Balik",
                            largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                            smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                            sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                            youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        let recipes = Recipes(recipes: [recipe])
        return recipes
    }
}

class MockRecipeServiceNetworkFailure: RecipeRetrieving {
    func retrieveRecipes(for url: String) async throws -> Recipes {
        throw URLError(.notConnectedToInternet)
    }
}

class MockRecipeServiceURLFailure: RecipeRetrieving {
    func retrieveRecipes(for url: String) async throws -> Recipes {
        throw RecipeServiceError.invalidURL
    }
}

class MockRecipeServiceDecodingFailure: RecipeRetrieving {
    func retrieveRecipes(for url: String) async throws -> Recipes {
        let recipe = Recipe(cuisine: "Malaysian",
                            name: "Apam Balik",
                            largePhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                            smallPhotoURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                            sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                            uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                            youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        let context = DecodingError.Context(codingPath: [[recipe].description.codingKey], debugDescription: "mock decoding error")
        throw DecodingError.dataCorrupted(context)
    }
}
