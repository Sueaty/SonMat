//
//  Step.swift
//  SonMat
//

import Foundation

struct Step: Identifiable, Codable, Hashable {
    let id: UUID
    let recipeID: UUID
    let stepNumber: Int
    let imageURL: String?
    let instruction: String

    enum CodingKeys: String, CodingKey {
        case id
        case recipeID = "recipe_id"
        case stepNumber = "step_number"
        case imageURL = "image_url"
        case instruction
    }
}
