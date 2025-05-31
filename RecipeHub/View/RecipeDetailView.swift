//
//  RecipeDetailView.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import SwiftUI

struct RecipeDetailViewWrapper: View {
    let recipe: Recipe

    var body: some View {
        RecipeDetailView(recipe: recipe)
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    @StateObject private var imageLoader: ImageLoader

    init(recipe: Recipe) {
        self.recipe = recipe
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: recipe.photo_url_large))
    }

    var body: some View {
        VStack {
            Text(recipe.cuisine)
                .bold()
                .font(.title2)
                .foregroundColor(.black)
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .padding()
            } else {
                ProgressView("Loading image...")
            }
        }
        .onAppear {
            imageLoader.load()
        }
        .onDisappear {
            imageLoader.cancel()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
