//
//  RecipeListViewModel.swift
//  SonMat
//

import Foundation
import Observation

@Observable
final class RecipeListViewModel {
    var recipes: [Recipe] = []
    var searchText: String = ""
    var selectedCategory: String = "전체"

    var categories: [String] {
        let unique = Set(recipes.map(\.category))
        return ["전체"] + unique.sorted()
    }

    var filteredRecipes: [Recipe] {
        let byCategory: [Recipe]
        if selectedCategory == "전체" {
            byCategory = recipes
        } else {
            byCategory = recipes.filter { $0.category == selectedCategory }
        }

        guard !searchText.isEmpty else { return byCategory }

        return byCategory.filter { recipe in
            recipe.title.localizedStandardContains(searchText) ||
            recipe.category.localizedStandardContains(searchText)
        }
    }
}
