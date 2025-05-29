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
}

final class RecipeService {
    static let shared = RecipeService()

    func getRecipes() async throws -> [Recipe] {
        guard let url = APIEndpoints.url else {
            fatalError("Invalid URL")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let decoded = try? JSONDecoder().decode([Recipe].self, from: data) else {
                throw RecipeServiceError.malformedData
            }
            return decoded
        } catch {
            throw RecipeServiceError.networkError(error)
        }
    }
}
