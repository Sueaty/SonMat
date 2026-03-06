//
//  RecipeListView.swift
//  SonMat
//

import SwiftUI

struct RecipeListView: View {
    @State private var viewModel = RecipeListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 2) {
                Text("손맛")
                    .font(.gmarket(26))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                Text("정성이 담긴 레시피 모음")
                    .font(.gmarket(13))
                    .foregroundStyle(Color.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 4)

            // Phase 4: search bar goes here
            // Phase 5: category chips go here

            // Content
            if viewModel.recipes.isEmpty {
                Spacer()
                ContentUnavailableView(
                    "아직 레시피가 없습니다",
                    systemImage: "fork.knife",
                    description: Text("곧 맛있는 요리가 추가될 예정이에요!")
                )
                Spacer()
            } else if viewModel.filteredRecipes.isEmpty {
                Spacer()
                ContentUnavailableView(
                    "검색 결과 없음",
                    systemImage: "magnifyingglass",
                    description: Text("다른 검색어로 다시 시도해 보세요")
                )
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.filteredRecipes) { recipe in
                            RecipeCardView(recipe: recipe)
                        }
                    }
                }
            }
        }
        .background(Color.appBg)
        .navigationBarHidden(true)
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
