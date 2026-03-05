//
//  StepCache.swift
//  SonMat
//

import Foundation
import SwiftData

@Model
final class StepCache {
    @Attribute(.unique) var id: UUID
    var recipeID: UUID
    var stepNumber: Int
    var imageURL: String?
    var instruction: String

    init(from step: Step) {
        self.id = step.id
        self.recipeID = step.recipeID
        self.stepNumber = step.stepNumber
        self.imageURL = step.imageURL
        self.instruction = step.instruction
    }

    func toStep() -> Step {
        Step(
            id: id,
            recipeID: recipeID,
            stepNumber: stepNumber,
            imageURL: imageURL,
            instruction: instruction
        )
    }
}
