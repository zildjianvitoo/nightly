//
//  AppTheme.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI
import UIKit

enum AppTheme {
    static let navy = color(
        light: rgba(34, 46, 120),
        dark: rgba(231, 235, 255)
    )
    static let indigo = color(
        light: rgba(35, 58, 170),
        dark: rgba(145, 156, 255)
    )
    static let periwinkle = color(
        light: rgba(132, 132, 230),
        dark: rgba(170, 168, 255)
    )
    static let sky = color(
        light: rgba(126, 212, 244),
        dark: rgba(108, 180, 240)
    )
    static let blush = color(
        light: rgba(246, 194, 206),
        dark: rgba(238, 162, 194)
    )

    static let background = color(
        light: rgba(244, 246, 255),
        dark: rgba(14, 18, 38)
    )
    static let backgroundGradient = LinearGradient(
        colors: [
            color(light: rgba(126, 212, 244, alpha: 0.22), dark: rgba(79, 125, 214, alpha: 0.28)),
            color(light: rgba(132, 132, 230, alpha: 0.18), dark: rgba(118, 104, 214, alpha: 0.24)),
            color(light: rgba(246, 194, 206, alpha: 0.22), dark: rgba(148, 86, 140, alpha: 0.2)),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardSurface = LinearGradient(
        colors: [
            color(light: rgba(255, 255, 255, alpha: 0.94), dark: rgba(36, 42, 79, alpha: 0.92)),
            color(light: rgba(239, 241, 255, alpha: 0.9), dark: rgba(24, 29, 61, alpha: 0.9)),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accent = indigo
    static let accentSoft = color(
        light: rgba(132, 132, 230, alpha: 0.2),
        dark: rgba(167, 169, 255, alpha: 0.22)
    )
    static let success = color(
        light: rgba(35, 58, 170),
        dark: rgba(123, 196, 255)
    )
    static let warning = color(
        light: rgba(226, 126, 164),
        dark: rgba(245, 154, 192)
    )
    static let textPrimary = color(
        light: rgba(34, 46, 120),
        dark: rgba(238, 241, 255)
    )
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let border = color(
        light: rgba(35, 58, 170, alpha: 0.12),
        dark: rgba(170, 168, 255, alpha: 0.2)
    )

    static let cardCornerRadius: CGFloat = 22
    static let cardPadding: CGFloat = 18
    static let screenPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18

    private static func color(light: UIColor, dark: UIColor) -> Color {
        Color(
            uiColor: UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        )
    }

    private static func rgba(
        _ red: CGFloat,
        _ green: CGFloat,
        _ blue: CGFloat,
        alpha: CGFloat = 1
    ) -> UIColor {
        UIColor(
            red: red / 255,
            green: green / 255,
            blue: blue / 255,
            alpha: alpha
        )
    }
}
