//
//  RecipeListViewModel.swift
//  SonMat
//

import Foundation
import Observation

@Observable
final class RecipeListViewModel {
    var recipes: [Recipe] = []
    var searchText: String = ""
    var selectedCategory: String = "전체"

    var categories: [String] {
        let unique = Set(recipes.map(\.category))
        return ["전체"] + unique.sorted()
    }

    var filteredRecipes: [Recipe] {
        let byCategory: [Recipe]
        if selectedCategory == "전체" {
            byCategory = recipes
        } else {
            byCategory = recipes.filter { $0.category == selectedCategory }
        }

        guard !searchText.isEmpty else { return byCategory }

        return byCategory.filter { recipe in
            recipe.title.localizedStandardContains(searchText) ||
            koreanContains(recipe.title, query: searchText) ||
            recipe.category.localizedStandardContains(searchText)
        }
    }

    // MARK: - Korean Jamo Matching

    // Decomposes Hangul syllables into individual jamo characters.
    // e.g. "김" → "ㄱㅣㅁ", enabling partial consonant search like "ㄱ" → "김치".
    private func decomposeKorean(_ text: String) -> String {
        let base: UInt32 = 0xAC00
        let chosung:  [Character] = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
        let jungsung: [Character] = ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"]
        let jongsung: [Character] = ["\0","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
        var result = ""
        for char in text {
            let code = char.unicodeScalars.first!.value
            if code >= base && code <= 0xD7A3 {
                let offset = code - base
                let cho  = Int(offset / (21 * 28))
                let jung = Int((offset % (21 * 28)) / 28)
                let jong = Int(offset % 28)
                result.append(chosung[cho])
                result.append(jungsung[jung])
                if jong != 0 { result.append(jongsung[jong]) }
            } else {
                result.append(char)
            }
        }
        return result
    }

    private func koreanContains(_ text: String, query: String) -> Bool {
        decomposeKorean(text.lowercased()).contains(decomposeKorean(query.lowercased()))
    }
}
