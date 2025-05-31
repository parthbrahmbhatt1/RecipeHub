//
//  RecipeService.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import Foundation

enum RecipeServiceError: Error, Equatable {
    case malformedData
    case networkError(Error)
    case invalidResponse

    static func == (lhs: RecipeServiceError, rhs: RecipeServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.malformedData, .malformedData), (.invalidResponse, .invalidResponse):
            return true
        case (.networkError, .networkError):
            return true // Or return false if you want to compare inner errors too
        default:
            return false
        }
    }
}

class RecipeService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getRecipes(from url: URL) async throws -> [Recipe] {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw RecipeServiceError.invalidResponse
            }

            let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decoded.recipes
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw RecipeServiceError.malformedData
        } catch {
            print("Other error: \(error)")
            throw RecipeServiceError.networkError(error)
        }
    }
}
