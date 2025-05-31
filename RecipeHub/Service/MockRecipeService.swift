//
//  MockRecipeService.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import Foundation

class MockRecipeService: RecipeService {
    var result: Result<[Recipe], RecipeServiceError> = .success([])

    override func getRecipes(from url: URL) async throws -> [Recipe] {
        return try result.get()
    }
}
