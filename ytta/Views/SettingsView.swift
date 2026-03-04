//
//  SettingsView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    enum ReminderAlert: String, Identifiable {
        case notificationsDenied
        case reminderFailed

        var id: String { rawValue }
    }

    @EnvironmentObject private var store: PrepStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var newItemTitle = ""
    @State private var showResetConfirmation = false
    @State private var reminderAlert: ReminderAlert?
    @State private var isUpdatingReminder = false
    @FocusState private var isAddItemFocused: Bool

    var body: some View {
        Form {
            everydayItemsSection
            reminderSection
            resetSection
        }
        .scrollDismissesKeyboard(.interactively)
        .simultaneousGesture(
            TapGesture().onEnded {
                isAddItemFocused = false
            }
        )
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $reminderAlert) { alert in
            switch alert {
            case .notificationsDenied:
                return Alert(
                    title: Text("Notifications Are Off"),
                    message: Text("Enable notifications in Settings to receive your nightly prep reminder."),
                    primaryButton: .default(Text("Open Settings")) {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        openURL(url)
                    },
                    secondaryButton: .cancel()
                )
            case .reminderFailed:
                return Alert(
                    title: Text("Reminder Could Not Be Saved"),
                    message: Text("Please try again in a moment."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private var everydayItemsSection: some View {
        Section {
            HStack(spacing: 12) {
                TextField("Add item", text: $newItemTitle)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .focused($isAddItemFocused)

                Button("Add", action: addItem)
                    .disabled(newItemTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if store.prep.items.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Nothing added yet")
                        .font(.subheadline.weight(.semibold))

                    Text("Add a few everyday essentials like your charger, bottle, or ID card.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.vertical, 6)
            } else {
                ForEach(store.prep.items) { item in
                    HStack {
                        Text(item.title)
                        Spacer()

                        if item.isDefault {
                            Text("Default")
                                .font(.caption)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                }
                .onDelete(perform: store.removeItems)
            }
        } header: {
            Text("Everyday Items")
        } footer: {
            Text("Swipe left on an item to remove it from tomorrow's checklist.")
        }
    }

    private var reminderSection: some View {
        Section {
            Toggle(
                "Prepare for tomorrow",
                isOn: Binding(
                    get: { store.prep.reminderEnabled },
                    set: { isEnabled in
                        Task {
                            await applyReminder(enabled: isEnabled, time: store.prep.reminderTime)
                        }
                    }
                )
            )
            .disabled(isUpdatingReminder)

            DatePicker(
                "Reminder Time",
                selection: Binding(
                    get: { store.prep.reminderTime },
                    set: { newTime in
                        Task {
                            if store.prep.reminderEnabled {
                                await applyReminder(enabled: true, time: newTime)
                            } else {
                                store.updateReminder(enabled: false, time: newTime)
                            }
                        }
                    }
                ),
                displayedComponents: .hourAndMinute
            )
            .disabled(!store.prep.reminderEnabled || isUpdatingReminder)
        } header: {
            Text("Nightly Reminder")
        } footer: {
            if isUpdatingReminder {
                Text("Saving your nightly reminder...")
            } else {
                Text("A gentle reminder helps keep tomorrow from turning rushed.")
            }
        }
    }

    private var resetSection: some View {
        Section {
            Button(role: .destructive) {
                showResetConfirmation = true
            } label: {
                Text("Reset for Tomorrow")
            }
        } footer: {
            Text("This clears tonight's progress but keeps your saved everyday items.")
        }
        .confirmationDialog(
            "Reset for tomorrow?",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) {
                store.resetForTomorrow()
                dismiss()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears tonight's progress but keeps your saved everyday items.")
        }
    }

    private func addItem() {
        store.addItem(title: newItemTitle)
        newItemTitle = ""
        isAddItemFocused = false
    }

    private func applyReminder(enabled: Bool, time: Date) async {
        isUpdatingReminder = true
        let result = await store.applyReminder(enabled: enabled, time: time)
        isUpdatingReminder = false

        switch result {
        case .scheduled, .disabled:
            break
        case .denied:
            reminderAlert = .notificationsDenied
        case .none:
            reminderAlert = .reminderFailed
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(PrepStore())
        }
    }
}
