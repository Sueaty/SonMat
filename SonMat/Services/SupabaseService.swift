//
//  SupabaseService.swift
//  SonMat
//

import Foundation
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()

    private let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: URL(string: SupabaseConfig.supabaseURL)!,
            supabaseKey: SupabaseConfig.supabaseAnonKey
        )
    }

    func fetchRecipes() async throws -> [Recipe] {
        try await client
            .from("recipes")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func fetchSteps(for recipeID: UUID) async throws -> [Step] {
        try await client
            .from("steps")
            .select()
            .eq("recipe_id", value: recipeID)
            .order("step_number")
            .execute()
            .value
    }
}
