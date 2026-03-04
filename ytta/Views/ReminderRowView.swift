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
                Image(systemName: store.prep.reminderEnabled ? "bell.badge.fill" : "bell")
                    .font(.title3)
                    .foregroundStyle(store.prep.reminderEnabled ? AppTheme.accent : AppTheme.textSecondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Nightly Reminder")
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text(reminderDescription)
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

    private var reminderDescription: String {
        if store.prep.reminderEnabled {
            return "Every night at \(store.prep.reminderTime.formatted(date: .omitted, time: .shortened))"
        }

        return "Night reminder is off. Tap to set one."
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
