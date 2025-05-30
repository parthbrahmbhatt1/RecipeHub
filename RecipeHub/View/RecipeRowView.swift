//
//  RecipeRowView.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/30/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @StateObject private var imageLoader: ImageLoader

    init(recipe: Recipe) {
        self.recipe = recipe
        _imageLoader = StateObject(wrappedValue: ImageLoader(url: recipe.photo_url_small))
    }

    var body: some View {
        HStack(spacing: 16) {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .onAppear {
            imageLoader.load()
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
