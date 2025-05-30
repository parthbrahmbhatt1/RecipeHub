//
//  ContentView.swift
//  RecipeHub
//
//  Created by Parth Brahmbhatt on 5/29/25.
//

import SwiftUI

struct RecipesListView: View {
    @StateObject private var viewModel = RecipesViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.recipes.isEmpty {
                    ProgressView("Loading Recipes...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 20) {
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                } else if viewModel.recipes.isEmpty {
                    VStack(spacing: 20) {
                        Text("No recipes available.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Button("Refresh") {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                } else {
                    List(viewModel.recipes) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                if viewModel.recipes.isEmpty {
                    await viewModel.refresh()
                }
            }
        }
    }
}
