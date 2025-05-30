//
//  RecipeModel.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import Foundation

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Codable, Identifiable {
    var id: String { uuid }
    let cuisine: String
    let name: String
    let photo_url_large: URL
    let photo_url_small: URL
    let uuid: String
    let source_url: URL?
    let youtube_url: URL?

    // Custom init to validate URLs? Codable auto does URL parsing
    // If any URL is invalid in JSON, decoding will fail (throws)
}
