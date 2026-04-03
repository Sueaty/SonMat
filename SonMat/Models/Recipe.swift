//
//  Recipe.swift
//  SonMat
//

import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let imageURL: String?
    let thumbnailURL: String?
    let category: String
    let prepTime: Int
    let cookTime: Int
    let servings: Int
    let ingredients: [String]
    let coupangProducts: [CoupangProduct]?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case category
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case servings
        case ingredients
        case coupangProducts = "coupang_products"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
