//
//  RecipeDetailView.swift
//  SonMat
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: Recipe

    @State private var detailViewModel = RecipeDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                metadataRow
                descriptionSection
                ingredientsSection
                stepsSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.appBg)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await detailViewModel.fetchSteps(for: recipe.id, context: modelContext)
        }
        .alert("오류", isPresented: Binding(
            get: { detailViewModel.errorMessage != nil },
            set: { if !$0 { detailViewModel.errorMessage = nil } }
        )) {
            Button("확인") { detailViewModel.errorMessage = nil }
        } message: {
            Text(detailViewModel.errorMessage ?? "")
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            CachedAsyncImage(
                url: recipe.imageURL.flatMap { URL(string: $0) },
                placeholder: { Color.chipBg }
            )
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipped()

            // Gradient overlay
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.35), location: 0),
                    .init(color: Color.clear, location: 0.4),
                    .init(color: Color.clear, location: 0.6),
                    .init(color: Color.black.opacity(0.5), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)

            // Category + title overlay
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.category)
                    .font(.gmarket(12))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(Color.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(recipe.title)
                    .font(.gmarket(28))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(height: 300)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding(.leading, 12)
        .padding(.top, 56)
    }

    // MARK: - Metadata

    private var metadataRow: some View {
        VStack(spacing: 0) {
            HStack {
                metadataItem(label: "준비 시간", value: "\(recipe.prepTime)분")
                Spacer()
                metadataItem(label: "조리 시간", value: "\(recipe.cookTime)분")
                Spacer()
                metadataItem(label: "인분", value: "\(recipe.servings)인분")
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)

            Rectangle()
                .fill(Color.chipBg)
                .frame(height: 0.5)
        }
    }

    private func metadataItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.gmarket(11))
                .foregroundStyle(Color.textTertiary)
            Text(value)
                .font(.gmarket(16))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
        }
    }

    // MARK: - Description

    private var descriptionSection: some View {
        Text(recipe.description)
            .font(.gmarket(14))
            .foregroundStyle(Color.textSecondary)
            .lineSpacing(5.8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("재료")
                .font(.gmarket(18))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)

            VStack(spacing: 0) {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 6, height: 6)

                        Text(ingredient)
                            .font(.gmarket(14))
                            .foregroundStyle(Color.textPrimary)

                        Spacer()
                    }
                    .padding(.vertical, 5)

                    if index < recipe.ingredients.count - 1 {
                        Rectangle()
                            .fill(Color(hex: "EEEDE9"))
                            .frame(height: 0.5)
                    }
                }
            }
            .padding(EdgeInsets(top: 9, leading: 16, bottom: 9, trailing: 16))
            .background(Color.chipBg)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    // MARK: - Steps

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("조리 방법")
                .font(.gmarket(18))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)

            if detailViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 20) {
                    ForEach(detailViewModel.steps) { step in
                        stepRow(step)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }

    private func stepRow(_ step: Step) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(step.stepNumber)")
                    .font(.gmarket(13))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.accent)
                    .clipShape(Circle())

                Text(step.instruction)
                    .font(.gmarket(14))
                    .foregroundStyle(Color.textPrimary)
                    .lineSpacing(5.8)
                    .padding(.top, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let imageURLString = step.imageURL, let url = URL(string: imageURLString) {
                CachedAsyncImage(url: url, placeholder: { Color.chipBg })
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.leading, 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe.mock[0])
    }
}
