//
//  AppTheme.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI
import UIKit

enum AppTheme {
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let accent = Color(uiColor: .systemTeal)
    static let accentSoft = Color(uiColor: .tertiarySystemFill)
    static let success = Color(uiColor: .systemGreen)
    static let warning = Color(uiColor: .systemOrange)
    static let textPrimary = Color(uiColor: .label)
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let border = Color(uiColor: .separator).opacity(0.12)

    static let cardCornerRadius: CGFloat = 22
    static let cardPadding: CGFloat = 18
    static let screenPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 18
}
