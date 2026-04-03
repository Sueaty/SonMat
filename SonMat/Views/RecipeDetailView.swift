//
//  RecipeDetailView.swift
//  SonMat
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
    let recipe: Recipe

    @State private var detailViewModel = RecipeDetailViewModel()
    @State private var firedScrollDepths: Set<Int> = []
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                heroSection
                metadataRow
                    .padding(.top, -10)
                    .zIndex(-1)
                descriptionSection
                ingredientsSection
                coupangSection
                stepsSection
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.appBg)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
        .background { NavigationGestureEnabler() }
        .onAppear {
            AnalyticsService.logScreenView(screenName: "recipe_detail")
            AnalyticsService.logRecipeViewed(
                recipeID: recipe.id.uuidString,
                title: recipe.title,
                category: recipe.category
            )
        }
        .onScrollGeometryChange(for: Double.self) { geo in
            let scrollable = geo.contentSize.height - geo.containerSize.height
            guard scrollable > 0 else { return 1.0 }
            return Double(geo.contentOffset.y / scrollable)
        } action: { _, ratio in
            for threshold in [25, 50, 75, 100] {
                if ratio * 100 >= Double(threshold) && !firedScrollDepths.contains(threshold) {
                    firedScrollDepths.insert(threshold)
                    AnalyticsService.logScrollDepth(recipeID: recipe.id.uuidString, depthPercent: threshold)
                }
            }
        }
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
            .accessibilityLabel("\(recipe.title) 요리 사진")

            // Gradient overlay
            LinearGradient(
                stops: [
                    .init(color: Color.black.opacity(0.13), location: 0),
                    .init(color: Color.clear, location: 0.3),
                    .init(color: Color.clear, location: 0.5),
                    .init(color: Color.black.opacity(0.67), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)
            .accessibilityHidden(true)

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
                    .font(.gmarket(30))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .accessibilityHidden(true)
        }
        .frame(height: 300)
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
        .accessibilityLabel("뒤로")
    }

    // MARK: - Metadata

    private var metadataRow: some View {
        HStack(spacing: 0) {
            metadataItem(icon: "timer", label: "준비 시간", value: "\(recipe.prepTime)분")
                .frame(maxWidth: .infinity)
            metadataItem(icon: "flame", label: "조리 시간", value: "\(recipe.cookTime)분")
                .frame(maxWidth: .infinity)
            metadataItem(icon: "person.2", label: "인분", value: "\(recipe.servings)인분")
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .background(Color.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.chipBg, radius: 10, x: 5, y: 5)
    }

    private func metadataItem(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accent)
            Text(label)
                .font(.gmarket(11))
                .foregroundStyle(Color.textTertiary)
            Text(value)
                .font(.gmarket(16))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label), \(value)")
    }

    // MARK: - Description

    private var descriptionSection: some View {
        Text(recipe.description)
            .font(.gmarket(14))
            .foregroundStyle(Color.textSecondary)
            .lineSpacing(5.8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 4)
    }

    // MARK: - Ingredients

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("재료")
                .font(.gmarket(18))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 8, height: 8)
                            .accessibilityHidden(true)

                        Text(ingredient)
                            .font(.gmarket(14))
                            .foregroundStyle(Color.textPrimary)

                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)

                    if index < recipe.ingredients.count - 1 {
                        Rectangle()
                            .fill(Color.ingredientDivider)
                            .frame(height: 1)
                    }
                }
            }
            .background(Color.accentLight)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }

    // MARK: - Coupang Products

    @ViewBuilder
    private var coupangSection: some View {
        if let products = recipe.coupangProducts, !products.isEmpty {
            VStack(alignment: .leading, spacing: 14) {
                // Header: 추천 상품 + Coupang badge
                HStack(spacing: 8) {
                    Text("추천 상품")
                        .font(.gmarket(18))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.textPrimary)
                        .accessibilityAddTraits(.isHeader)

                    Text("Coupang")
                        .font(.gmarket(11))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background(Color.accentLight)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                // Horizontal scrolling product cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(products) { product in
                            Button {
                                if let url = URL(string: product.productURL) {
                                    openURL(url)
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    CachedAsyncImage(
                                        url: URL(string: product.thumbnailURL),
                                        placeholder: { Color.chipBg }
                                    )
                                    .frame(width: 130, height: 130)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                    Text(product.name)
                                        .font(.gmarket(12))
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color.textPrimary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 130, alignment: .leading)
                                }
                            }
                            .accessibilityLabel("\(product.name), 쿠팡에서 구매하기")
                        }
                    }
                }

                // Disclosure text
                Text("쿠팡 파트너스 활동의 일환으로, 이에 따른 일정액의 수수료를 제공받습니다.")
                    .font(.gmarket(10))
                    .foregroundStyle(Color.textTertiary)
                    .lineSpacing(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
    }

    // MARK: - Steps

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("조리 방법")
                .font(.gmarket(18))
                .fontWeight(.bold)
                .foregroundStyle(Color.textPrimary)
                .accessibilityAddTraits(.isHeader)

            if detailViewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .accessibilityLabel("조리 방법 불러오는 중")
            } else {
                VStack(spacing: 20) {
                    ForEach(Array(detailViewModel.steps.enumerated()), id: \.element.id) { index, step in
                        stepRow(step, isLast: index == detailViewModel.steps.count - 1)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 20)
    }

    private func stepRow(_ step: Step, isLast: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(step.stepNumber)")
                    .font(.gmarket(13))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.accent)
                    .clipShape(Circle())
                    .accessibilityHidden(true)

                Text(step.instruction)
                    .font(.gmarket(14))
                    .foregroundStyle(Color.textPrimary)
                    .lineSpacing(5.8)
                    .padding(.top, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityLabel("\(step.stepNumber)단계: \(step.instruction)")
            }

            if let imageURLString = step.imageURL, let url = URL(string: imageURLString) {
                CachedAsyncImage(url: url, placeholder: { Color.chipBg })
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.leading, 40)
                    .accessibilityLabel("\(step.stepNumber)단계 조리 사진")
            }
        }
        .padding(.bottom, isLast ? 0 : 16)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(Color.separator)
                    .frame(height: 1)
            }
        }
    }

}

private struct NavigationGestureEnabler: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        GestureEnablerController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class GestureEnablerController: UIViewController {
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: Recipe.mock[0])
    }
}
