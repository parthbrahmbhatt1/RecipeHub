//
//  RecipeDetailViewModel.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import Foundation

class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe

   

    init(recipe: Recipe) {
        self.recipe = recipe
    }
}
