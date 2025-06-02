//
//  RecipeViewModelTest.swift
//  RecipeHubTests
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import XCTest
@testable import RecipeHub

final class RecipesViewModelTests: XCTestCase {
    
    func testRefreshWithValidRecipes() async {
        let mockService = MockRecipeService()
        let sampleRecipe = Recipe(
            cuisine: "British",
            name: "Apple & Blackberry Crumble",
            photo_url_large: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")!,
            photo_url_small: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg")!,
            uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
            source_url: URL(string: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble"),
            youtube_url: URL(string: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
        )
        mockService.result = .success([sampleRecipe])
        let viewModel = RecipesViewModel(service: mockService)
        
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Apple & Blackberry Crumble")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRefreshWithEmptyRecipes() async {
        let mockService = MockRecipeService()
        mockService.result = .success([])
        let viewModel = RecipesViewModel(service: mockService)
        
        await viewModel.refresh()
        
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRefreshWithMalformedError() async {
        let mockService = MockRecipeService()
        mockService.result = .failure(.malformedData)
        let viewModel = RecipesViewModel(service: mockService)
        
        await viewModel.refresh()
        
        XCTAssertTrue(viewModel.recipes.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Failed to parse recipes data.")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testRefreshWithNetworkError() async {
        let mockService = MockRecipeService()
        let underlying = NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No Internet"])
        mockService.result = .failure(.networkError(underlying))
        let viewModel = RecipesViewModel(service: mockService)
        
        await viewModel.refresh()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Network error: No Internet")
        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
}
