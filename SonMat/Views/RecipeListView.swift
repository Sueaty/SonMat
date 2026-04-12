//
//  RecipeListView.swift
//  SonMat
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Bindable var viewModel: RecipeListViewModel
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SavedRecipeCache.savedAt, order: .reverse) private var savedEntries: [SavedRecipeCache]

    private var savedRecipes: [Recipe] {
        savedEntries.compactMap { entry in
            viewModel.recipes.first { $0.id == entry.recipeID }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
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
            .padding(.bottom, 0)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                    .accessibilityLabel("레시피 불러오는 중")
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        if !savedRecipes.isEmpty {
                            savedSection
                        }

                        Section {
                            if viewModel.recipes.isEmpty {
                                ContentUnavailableView(
                                    "아직 레시피가 없습니다",
                                    systemImage: "fork.knife",
                                    description: Text("곧 맛있는 요리가 추가될 예정이에요!")
                                )
                                .padding(.top, 60)
                            } else if viewModel.filteredRecipes.isEmpty {
                                ContentUnavailableView(
                                    "검색 결과 없음",
                                    systemImage: "magnifyingglass",
                                    description: Text("다른 검색어로 다시 시도해 보세요")
                                )
                                .padding(.top, 60)
                            } else {
                                LazyVStack(spacing: 0) {
                                    ForEach(viewModel.filteredRecipes) { recipe in
                                        NavigationLink(value: recipe) {
                                            RecipeCardView(recipe: recipe)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }
                        } header: {
                            VStack(spacing: 0) {
                                SearchBarView(text: $viewModel.searchText)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                    .padding(.bottom, 8)
                                CategoryChipsView(
                                    categories: viewModel.categories,
                                    selectedCategory: $viewModel.selectedCategory
                                )
                            }
                            .background(Color.appBg)
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

    private var savedSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("저장한 레시피")
                    .font(.gmarket(15))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(savedRecipes) { recipe in
                        NavigationLink(value: recipe) {
                            SavedRecipeCardView(recipe: recipe)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 4)
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
                            .foregroundStyle(selectedCategory == category ? Color.chipSelectedText : Color.textPrimary)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(selectedCategory == category ? Color.accent : Color.chipBg)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(category)
                    .accessibilityAddTraits(selectedCategory == category ? .isSelected : [])
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 12)
    }
}

#Preview {
    NavigationStack {
        RecipeListView(viewModel: RecipeListViewModel())
    }
}
