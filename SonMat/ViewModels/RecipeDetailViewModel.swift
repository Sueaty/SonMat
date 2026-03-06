//
//  RecipeDetailViewModel.swift
//  SonMat
//

import Foundation
import Observation
import SwiftData

@Observable
final class RecipeDetailViewModel {
    var steps: [Step] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    @MainActor
    func fetchSteps(for recipeID: UUID, context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetched = try await SupabaseService.shared.fetchSteps(for: recipeID)
            try context.delete(model: StepCache.self, where: #Predicate { $0.recipeID == recipeID })
            for step in fetched {
                context.insert(StepCache(from: step))
            }
            steps = fetched.sorted { $0.stepNumber < $1.stepNumber }
        } catch {
            // Fall back to SwiftData cache
            do {
                let descriptor = FetchDescriptor<StepCache>(
                    predicate: #Predicate { $0.recipeID == recipeID }
                )
                let cached = try context.fetch(descriptor)
                steps = cached.map { $0.toStep() }.sorted { $0.stepNumber < $1.stepNumber }
                if !steps.isEmpty {
                    errorMessage = "네트워크 오류로 저장된 데이터를 표시합니다."
                }
            } catch {
                steps = []
            }
        }
    }
}
