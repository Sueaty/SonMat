//
//  RecipeCache.swift
//  SonMat
//

import Foundation
import SwiftData

@Model
final class RecipeCache {
    @Attribute(.unique) var id: UUID
    var title: String
    var recipeDescription: String
    var imageURL: String?
    var thumbnailURL: String?
    var category: String
    var prepTime: Int
    var cookTime: Int
    var servings: Int
    var ingredients: [String]
    var coupangProducts: [CoupangProduct]?
    var createdAt: Date
    var updatedAt: Date

    init(from recipe: Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.recipeDescription = recipe.description
        self.imageURL = recipe.imageURL
        self.thumbnailURL = recipe.thumbnailURL
        self.category = recipe.category
        self.prepTime = recipe.prepTime
        self.cookTime = recipe.cookTime
        self.servings = recipe.servings
        self.ingredients = recipe.ingredients
        self.coupangProducts = recipe.coupangProducts
        self.createdAt = recipe.createdAt
        self.updatedAt = recipe.updatedAt
    }

    func toRecipe() -> Recipe {
        Recipe(
            id: id,
            title: title,
            description: recipeDescription,
            imageURL: imageURL,
            thumbnailURL: thumbnailURL,
            category: category,
            prepTime: prepTime,
            cookTime: cookTime,
            servings: servings,
            ingredients: ingredients,
            coupangProducts: coupangProducts,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
