//
//  ReminderRowView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct ReminderRowView: View {
    @EnvironmentObject private var store: PrepStore

    var body: some View {
        NavigationLink {
            SettingsView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Prep Center")
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text(actionDescription)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
            }
            .padding(AppTheme.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .fill(AppTheme.cardSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .stroke(AppTheme.border)
            )
        }
        .buttonStyle(.plain)
    }

    private var actionDescription: String {
        if store.prep.reminderEnabled {
            return "Items and reminder set for \(store.prep.reminderTime.formatted(date: .omitted, time: .shortened))."
        }

        return "Organize your checklist and nightly reminder."
    }
}

struct ReminderRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReminderRowView()
                .padding()
                .background(AppTheme.background)
                .environmentObject(PrepStore())
        }
    }
}
