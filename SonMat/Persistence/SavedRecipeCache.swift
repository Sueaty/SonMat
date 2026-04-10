//
//  SavedRecipeCache.swift
//  SonMat
//

import SwiftData
import Foundation

@Model
final class SavedRecipeCache {
    @Attribute(.unique) var recipeID: UUID
    var savedAt: Date

    init(recipeID: UUID) {
        self.recipeID = recipeID
        self.savedAt = Date()
    }
}
