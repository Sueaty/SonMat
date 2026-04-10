//
//  SavedRecipeCardView.swift
//  SonMat
//

import SwiftUI

struct SavedRecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CachedAsyncImage(
                url: recipe.thumbnailURL.flatMap { URL(string: $0) },
                placeholder: { Color.chipBg }
            )
            .frame(width: 110, height: 80)
            .clipShape(
                .rect(
                    topLeadingRadius: 14,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 14
                )
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.title)
                    .font(.gmarket(13))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                Text("\(recipe.category) · \(recipe.prepTime + recipe.cookTime)분")
                    .font(.gmarket(11))
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 8)
            .padding(.top, 6)
            .padding(.bottom, 8)
        }
        .frame(width: 110)
        .background(Color.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
