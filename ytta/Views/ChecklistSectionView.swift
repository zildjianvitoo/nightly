//
//  ChecklistSectionView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct ChecklistSectionView: View {
    @EnvironmentObject private var store: PrepStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader

            if store.prep.items.isEmpty {
                emptyState
            } else {
                VStack(spacing: 10) {
                    ForEach(store.prep.items) { item in
                        checklistRow(for: item)
                    }
                }
            }
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

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("What to Bring", systemImage: "backpack")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Text("Check off what is already packed for tomorrow.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
    }

    private func checklistRow(for item: PrepItem) -> some View {
        Button {
            store.toggleItem(item)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isChecked ? AppTheme.success : AppTheme.textSecondary)

                Text(item.title)
                    .font(.body)
                    .foregroundStyle(AppTheme.textPrimary)
                    .strikethrough(item.isChecked, color: AppTheme.textSecondary)

                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.title)
        .accessibilityValue(item.isChecked ? "Checked" : "Not checked")
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Nothing added yet")
                .font(.subheadline.weight(.semibold))

            Text("Add a few everyday essentials like your charger, bottle, or ID card.")
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.background)
        )
    }
}

struct ChecklistSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistSectionView()
            .padding()
            .background(AppTheme.background)
            .environmentObject(PrepStore())
    }
}
