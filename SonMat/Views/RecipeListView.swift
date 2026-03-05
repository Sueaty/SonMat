//
//  RecipeListView.swift
//  SonMat
//

import SwiftUI

struct RecipeListView: View {
    @State private var viewModel = RecipeListViewModel()

    var body: some View {
        List(viewModel.filteredRecipes) { recipe in
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.headline)
                Text(recipe.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("손맛")
        .onAppear {
            // Phase 8: replace with live Supabase fetch + SwiftData fallback
            if viewModel.recipes.isEmpty {
                viewModel.recipes = Recipe.mock
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeListView()
    }
}
