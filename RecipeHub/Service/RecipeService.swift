//
//  RecipeService.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import Foundation

enum RecipeServiceError: Error {
    case malformedData
    case networkError(Error)
    case invalidResponse
}

class RecipeService {
    
    func getRecipes(from url: URL) async throws -> [Recipe] {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch {
            throw RecipeServiceError.malformedData
        }
    }
}
