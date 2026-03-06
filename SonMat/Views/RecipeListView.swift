//
//  RecipeListView.swift
//  SonMat
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @State private var viewModel = RecipeListViewModel()
    @Environment(\.modelContext) private var modelContext

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

            SearchBarView(text: $viewModel.searchText)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 8)

            CategoryChipsView(
                categories: viewModel.categories,
                selectedCategory: $viewModel.selectedCategory
            )

            // Content
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if viewModel.recipes.isEmpty {
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
                            NavigationLink(value: recipe) {
                                RecipeCardView(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
        .background(Color.appBg)
        .navigationBarHidden(true)
        .onAppear {
            AnalyticsService.logScreenView(screenName: "recipe_list")
        }
        .task {
            await viewModel.fetchRecipes(context: modelContext)
        }
        .alert("오류", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("확인") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

private struct CategoryChipsView: View {
    let categories: [String]
    @Binding var selectedCategory: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                        AnalyticsService.logCategoryFilterTapped(category: category)
                    } label: {
                        Text(category)
                            .font(.gmarket(13))
                            .foregroundStyle(selectedCategory == category ? Color.white : Color.textPrimary)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(selectedCategory == category ? Color.textPrimary : Color.chipBg)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }
}

#Preview {
    NavigationStack {
        RecipeListView()
    }
}
