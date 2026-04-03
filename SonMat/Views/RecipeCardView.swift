//
//  RecipeCardView.swift
//  SonMat
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            // Thumbnail
            CachedAsyncImage(
                url: recipe.thumbnailURL.flatMap { URL(string: $0) },
                placeholder: {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.chipBg)
                }
            )
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.title)
                    .font(.gmarket(16))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.textPrimary)

                HStack(spacing: 8) {
                    Text(recipe.category)
                        .font(.gmarket(11))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accent)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background(Color.accentLight)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    Text("\(recipe.prepTime + recipe.cookTime)분")
                        .font(.gmarket(12))
                        .foregroundStyle(Color.textTertiary)
                }

                Text(recipe.description)
                    .font(.gmarket(13))
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(recipe.title), \(recipe.category), 총 \(recipe.prepTime + recipe.cookTime)분")
        .accessibilityHint("레시피 상세 보기")
        .padding(12)
        .background(Color.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RecipeCardView(recipe: Recipe.mock[0])
}
