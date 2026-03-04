//
//  PrepHomeView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct PrepHomeView: View {
    @EnvironmentObject private var store: PrepStore
    @State private var showReadyCelebration = false
    @State private var lastKnownReadyState = false
    @State private var celebrationDismissTask: Task<Void, Never>?
    @State private var activePlanField: HomePlanField?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                header
                ReadinessCardView()
                ChecklistSectionView()
                ReminderRowView()
                tomorrowPlanOverview
            }
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                AppTheme.backgroundGradient.ignoresSafeArea()
            }
        }
        .overlay(alignment: .top) {
            if showReadyCelebration {
                ReadyCelebrationView()
                    .padding(.horizontal, AppTheme.screenPadding)
                    .padding(.top, 6)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .scale(scale: 0.96).combined(with: .opacity)
                        )
                    )
                    .zIndex(1)
            }
        }
        .onAppear {
            lastKnownReadyState = store.isFullyPrepared
        }
        .onDisappear {
            celebrationDismissTask?.cancel()
        }
        .onChange(of: store.isFullyPrepared) { _, isFullyPrepared in
            guard isFullyPrepared != lastKnownReadyState else {
                return
            }

            lastKnownReadyState = isFullyPrepared
            celebrationDismissTask?.cancel()

            guard isFullyPrepared else {
                withAnimation(.easeOut(duration: 0.5)) {
                    showReadyCelebration = false
                }
                return
            }

            withAnimation(.spring(duration: 0.45)) {
                showReadyCelebration = true
            }

            celebrationDismissTask = Task {
                try? await Task.sleep(nanoseconds: 2_500_000_000)

                guard !Task.isCancelled else {
                    return
                }

                await MainActor.run {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showReadyCelebration = false
                    }
                }
            }
        }
        .sheet(item: $activePlanField) { field in
            HomePlanEditorSheet(field: field, text: planBinding(for: field))
                .presentationDetents(field.isMultiline ? [.medium, .large] : [.fraction(0.32), .medium])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("Prep for Tomorrow")
        .navigationBarTitleDisplayMode(.large)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Finish tonight in under three minutes.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.textSecondary)

            Text("Set out the essentials now so the morning feels lighter.")
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)

            if store.completionProgress == 0 {
                Label("Start with your bag, then outfit, then breakfast.", systemImage: "sparkles")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(AppTheme.accent)
                    .padding(.top, 4)
            }
        }
        .padding(.top, 4)
    }

    private var tomorrowPlanOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tomorrow Plan")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            planSummaryCard(
                field: .outfit,
                title: "What to Wear",
                icon: "tshirt",
                value: store.prep.outfit,
                emptyPrompt: "Outfit not set yet.",
                ctaText: "Tap to set outfit"
            )

            planSummaryCard(
                field: .breakfast,
                title: "Breakfast Plan",
                icon: "fork.knife",
                value: store.prep.breakfast,
                emptyPrompt: "Breakfast not planned yet.",
                ctaText: "Tap to set breakfast"
            )

            planSummaryCard(
                field: .notes,
                title: "Important Notes",
                icon: "note.text",
                value: store.prep.notes,
                emptyPrompt: "No notes for tomorrow yet.",
                ctaText: "Tap to add notes"
            )
        }
    }

    private func planSummaryCard(
        field: HomePlanField,
        title: String,
        icon: String,
        value: String,
        emptyPrompt: String,
        ctaText: String
    ) -> some View {
        let cleanedValue = value.trimmed
        let hasValue = !cleanedValue.isEmpty

        return Button {
            activePlanField = field
        } label: {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Label(title, systemImage: icon)
                        .font(.headline)
                        .foregroundStyle(AppTheme.textPrimary)

                    if hasValue {
                        Text(cleanedValue)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text(emptyPrompt)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary.opacity(0.85))

                        Label(ctaText, systemImage: "plus.circle.fill")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(AppTheme.accent)
                    }
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.textSecondary)
                    .padding(.top, 3)
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

    private func planBinding(for field: HomePlanField) -> Binding<String> {
        switch field {
        case .outfit:
            return Binding(
                get: { store.prep.outfit },
                set: store.updateOutfit
            )
        case .breakfast:
            return Binding(
                get: { store.prep.breakfast },
                set: store.updateBreakfast
            )
        case .notes:
            return Binding(
                get: { store.prep.notes },
                set: store.updateNotes
            )
        }
    }
}

struct PrepHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PrepHomeView()
                .environmentObject(PrepStore())
        }
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private enum HomePlanField: String, Identifiable {
    case outfit
    case breakfast
    case notes

    var id: String { rawValue }

    var title: String {
        switch self {
        case .outfit:
            return "What to Wear"
        case .breakfast:
            return "Breakfast Plan"
        case .notes:
            return "Important Notes"
        }
    }

    var placeholder: String {
        switch self {
        case .outfit:
            return "School uniform, black hoodie, sneakers..."
        case .breakfast:
            return "Overnight oats, toast, banana..."
        case .notes:
            return "Bring assignment, leave by 6:30, refill bottle..."
        }
    }

    var keyboardAutocapitalization: TextInputAutocapitalization {
        switch self {
        case .outfit:
            return .words
        case .breakfast, .notes:
            return .sentences
        }
    }

    var isMultiline: Bool {
        self == .notes
    }
}

private struct HomePlanEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isInputFocused: Bool

    let field: HomePlanField
    @Binding var text: String

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if field.isMultiline {
                    ZStack(alignment: .topLeading) {
                        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            Text(field.placeholder)
                                .font(.body)
                                .foregroundStyle(AppTheme.textSecondary.opacity(0.55))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 8)
                        }

                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .frame(minHeight: 160)
                            .font(.body)
                            .foregroundStyle(AppTheme.textPrimary)
                            .focused($isInputFocused)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppTheme.background.opacity(0.75))
                    )
                } else {
                    TextField(field.placeholder, text: $text, axis: .vertical)
                        .textInputAutocapitalization(field.keyboardAutocapitalization)
                        .autocorrectionDisabled()
                        .focused($isInputFocused)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(AppTheme.background.opacity(0.75))
                        )
                }

                Spacer(minLength: 0)
            }
            .padding(20)
            .background {
                ZStack {
                    AppTheme.background.ignoresSafeArea()
                    AppTheme.backgroundGradient.ignoresSafeArea()
                }
            }
            .navigationTitle(field.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isInputFocused = true
            }
        }
    }
}
