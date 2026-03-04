//
//  PrepHomeView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct PrepHomeView: View {
    @EnvironmentObject private var store: PrepStore
    @FocusState private var isOutfitFocused: Bool
    @FocusState private var isBreakfastFocused: Bool
    @FocusState private var isNotesFocused: Bool
    @State private var showReadyCelebration = false
    @State private var lastKnownReadyState = false
    @State private var celebrationDismissTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                header
                ReadinessCardView()
                ChecklistSectionView()

                PlanSectionView(
                    title: "What to Wear",
                    icon: "tshirt",
                    placeholder: "School uniform, black hoodie, sneakers...",
                    text: Binding(
                        get: { store.prep.outfit },
                        set: store.updateOutfit
                    ),
                    isFocused: $isOutfitFocused
                )

                PlanSectionView(
                    title: "Breakfast Plan",
                    icon: "fork.knife",
                    placeholder: "Overnight oats, toast, banana...",
                    text: Binding(
                        get: { store.prep.breakfast },
                        set: store.updateBreakfast
                    ),
                    isFocused: $isBreakfastFocused
                )

                PlanSectionView(
                    title: "Important Notes",
                    icon: "note.text",
                    placeholder: "Bring assignment, leave by 6:30, refill bottle...",
                    text: Binding(
                        get: { store.prep.notes },
                        set: store.updateNotes
                    ),
                    isFocused: $isNotesFocused,
                    axis: .vertical,
                    minHeight: 112
                )

                ReminderRowView()
            }
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppTheme.background.ignoresSafeArea())
        .simultaneousGesture(
            TapGesture().onEnded {
                clearFocus()
            }
        )
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

    private func clearFocus() {
        isOutfitFocused = false
        isBreakfastFocused = false
        isNotesFocused = false
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
