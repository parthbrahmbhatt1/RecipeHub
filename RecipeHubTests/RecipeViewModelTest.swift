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
            name: "Bakewell Tart",
            photo_url_large: URL(string: "https://some.url/large.jpg")!,
            photo_url_small: URL(string: "https://some.url/small.jpg")!,
            uuid: "uuid",
            source_url: URL(string: "https://some.url"),
            youtube_url: URL(string: "https://youtube.com")
        )
        mockService.result = .success([sampleRecipe])
        let viewModel = RecipesViewModel(service: mockService)

        await viewModel.refresh()

        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Bakewell Tart")
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
}
