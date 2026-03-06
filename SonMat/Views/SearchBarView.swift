//
//  SearchBarView.swift
//  SonMat
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.textTertiary)
                .font(.system(size: 16))
                .accessibilityHidden(true)
            TextField("레시피 검색...", text: $text)
                .font(.gmarket(15))
                .foregroundStyle(Color.textPrimary)
                .tint(Color.accent)
                .accessibilityLabel("레시피 검색")
            if !text.isEmpty {
                Button { text = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textTertiary)
                        .font(.system(size: 16))
                }
                .accessibilityLabel("검색어 지우기")
                .accessibilityHint("현재 입력된 검색어를 지웁니다")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.chipBg, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    SearchBarView(text: .constant(""))
        .padding()
}
