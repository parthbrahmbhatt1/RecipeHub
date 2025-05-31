//
//  RecipeListViewModel.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var selectedCuisine: String? = nil
    
    private let service: RecipeService
    private let url: URL

    init(service: RecipeService = RecipeService(),
         url: URL = APIConstants.Endpoints.allRecipes) {
        self.service = service
        self.url = url
    }
    
    var cuisines: [String] {
        let all = Set(recipes.map { $0.cuisine })
        return Array(all).sorted()
    }
    
    var filteredRecipes: [Recipe] {
            var filtered = recipes

            if let selected = selectedCuisine {
                filtered = filtered.filter { $0.cuisine == selected }
            }

            if !searchText.isEmpty {
                filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }

            return filtered
        }



    @MainActor
    func refresh() async {
        isLoading = true
        errorMessage = nil
        do {
            let getRecipes = try await service.getRecipes(from: url)
            if getRecipes.isEmpty {
                recipes = []
            } else {
                recipes = getRecipes.sorted { $0.name < $1.name }
            }
        } catch RecipeServiceError.malformedData {
            errorMessage = "Failed to parse recipes data."
            recipes = []
        } catch RecipeServiceError.networkError(let error) {
            errorMessage = "Network error: \(error.localizedDescription)"
            recipes = []
        } catch {
            errorMessage = "Unknown error: \(error.localizedDescription)"
            recipes = []
        }
        isLoading = false
    }
}
