//
//  ColorExtensions.swift
//  SonMat
//

import SwiftUI

// MARK: - UIColor hex initializer

private extension UIColor {
    convenience init(hex: String) {
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
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, alpha: 1)
    }
}

// MARK: - Color extension

extension Color {
    /// Creates a color that adapts to light/dark mode.
    init(light lightHex: String, dark darkHex: String) {
        self.init(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(hex: darkHex)
                : UIColor(hex: lightHex)
        })
    }

    /// Legacy single-hex initializer (fixed color, no dark mode adaptation).
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

    // MARK: Design system colors

    static let accent            = Color(light: "C4533A", dark: "E07550")
    static let accentDark        = Color(light: "A8412B", dark: "C45A35")
    static let accentLight       = Color(light: "FDF0EB", dark: "3D2318")
    static let cardBg            = Color(light: "FFFFFF", dark: "2A2926")
    static let appBg             = Color(light: "F7F5F0", dark: "1C1B19")
    static let textPrimary       = Color(light: "2B2520", dark: "F2EDE8")
    static let textSecondary     = Color(light: "6B6158", dark: "A8A8A8")
    static let textTertiary      = Color(light: "9C9488", dark: "9E9E9E")
    static let chipBg            = Color(light: "EFEBE4", dark: "2C2B28")
    /// Thin divider inside the ingredients box.
    static let ingredientDivider = Color(light: "E8E4DC", dark: "3A3936")
    /// Text color for the selected category chip (inverts with the chip background).
    static let chipSelectedText  = Color(light: "FFFFFF", dark: "1C1B19")
    /// Separator between steps.
    static let separator         = Color(light: "EDE9E1", dark: "3A3936")
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
