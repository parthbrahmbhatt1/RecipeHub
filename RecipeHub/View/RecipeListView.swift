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
                if viewModel.isLoading && viewModel.filteredRecipes.isEmpty {
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
                } else if viewModel.filteredRecipes.isEmpty {
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
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    RecipeRowView(recipe: recipe)
                                        .padding(.leading, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                                            .foregroundColor(.gray)
                                                            .padding(.trailing, 10)

                                }
                                Divider()
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Recipes")
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
            .task {
                if viewModel.recipes.isEmpty {
                    await viewModel.refresh()
                }
            }
        }
    }
}
