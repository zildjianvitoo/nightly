//
//  ReadinessCardView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct ReadinessCardView: View {
    @EnvironmentObject private var store: PrepStore

    var body: some View {
        HStack(spacing: 18) {
            progressRing

            VStack(alignment: .leading, spacing: 8) {
                Text(store.readinessTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(store.readinessMessage)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)

                Label(progressLabel, systemImage: statusSymbol)
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(statusColor)
                    .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
        .padding(AppTheme.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .stroke(AppTheme.border)
        )
        .accessibilityElement(children: .combine)
        .animation(.spring(duration: 0.35), value: store.completionProgress)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.accentSoft, lineWidth: 10)

            Circle()
                .trim(from: 0, to: max(store.completionProgress, 0.02))
                .stroke(statusColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))

            VStack(spacing: 2) {
                Text("\(progressPercent)%")
                    .font(.headline.weight(.semibold))
                    .monospacedDigit()

                Text("Ready")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .frame(width: 86, height: 86)
    }

    private var progressLabel: String {
        "\(progressPercent)% ready for tomorrow"
    }

    private var progressPercent: Int {
        Int((store.completionProgress * 100).rounded())
    }

    private var statusSymbol: String {
        switch store.readinessStatus {
        case .notReady:
            return "moon.stars"
        case .almostReady:
            return "checkmark.circle"
        case .readyForTomorrow:
            return "checkmark.circle.fill"
        }
    }

    private var statusColor: Color {
        switch store.readinessStatus {
        case .notReady:
            return AppTheme.warning
        case .almostReady:
            return AppTheme.accent
        case .readyForTomorrow:
            return AppTheme.success
        }
    }
}

struct ReadinessCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReadinessCardView()
            .padding()
            .background(AppTheme.background)
            .environmentObject(PrepStore())
    }
}
