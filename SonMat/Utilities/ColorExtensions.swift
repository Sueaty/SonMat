//
//  ColorExtensions.swift
//  SonMat
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }

    static let accent       = Color(hex: "D4603A")
    static let accentLight  = Color(hex: "FDF0EB")
    static let appBg        = Color(hex: "FAFAF8")
    static let textPrimary  = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "6B6B6B")
    static let textTertiary = Color(hex: "6E6E6E")
    static let chipBg       = Color(hex: "F0EFEC")
}

extension Font {
    static func gmarket(_ size: CGFloat) -> Font {
        let style: Font.TextStyle
        switch size {
        case ..<12: style = .caption2
        case ..<14: style = .caption
        case ..<16: style = .subheadline
        case ..<18: style = .body
        case ..<22: style = .title3
        case ..<26: style = .title2
        default:    style = .largeTitle
        }
        return .custom("GmarketSansMedium", size: size, relativeTo: style)
    }
}
