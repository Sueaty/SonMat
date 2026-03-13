//
//  InfoView.swift
//  SonMat
//

import SwiftUI

struct InfoView: View {
    @Environment(\.openURL) private var openURL

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                Text("정보")
                    .font(.gmarket(26))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                    .padding(.bottom, 16)

                VStack(spacing: 16) {
                    // App info card
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(
                                colors: [.accent, .accentDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 72, height: 72)
                            .overlay {
                                Text("손")
                                    .font(.gmarket(32))
                                    .foregroundStyle(.white)
                            }
                            .accessibilityHidden(true)

                        Text("손맛")
                            .font(.gmarket(20))
                            .foregroundStyle(Color.textPrimary)

                        Text("버전 \(appVersion)")
                            .font(.gmarket(13))
                            .foregroundStyle(Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                    .background(Color.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.ingredientDivider, lineWidth: 0.5)
                    )

                    // Links card
                    VStack(spacing: 0) {
                        InfoRow(
                            systemImage: "lock.fill",
                            title: "개인정보 처리방침",
                            subtitle: "개인정보 보호 및 처리에 관한 안내"
                        ) {
                            if let url = URL(string: "https://sueaty.github.io/SonMat/privacy/") {
                                openURL(url)
                            }
                        }
                        Divider()
                            .padding(.leading, 56)
                        InfoRow(
                            systemImage: "camera.fill",
                            title: "문의하기",
                            subtitle: "인스타그램 @뚜뚜"
                        ) {
                            if let url = URL(string: "https://www.instagram.com/ddduuuddduuu__") {
                                openURL(url)
                            }
                        }
                    }
                    .background(Color.cardBg)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.ingredientDivider, lineWidth: 0.5)
                    )

                    Text("© 2026 손맛. All rights reserved.")
                        .font(.gmarket(11))
                        .foregroundStyle(Color.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .background(Color.appBg)
        .navigationBarHidden(true)
        .onAppear {
            AnalyticsService.logScreenView(screenName: "info")
        }
    }
}

// MARK: - InfoRow

private struct InfoRow: View {
    let systemImage: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.accent)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.gmarket(15))
                        .foregroundStyle(Color.textPrimary)
                    Text(subtitle)
                        .font(.gmarket(12))
                        .foregroundStyle(Color.textTertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .accessibilityLabel(title)
        .accessibilityHint(subtitle)
    }
}

#Preview {
    NavigationStack {
        InfoView()
    }
}
