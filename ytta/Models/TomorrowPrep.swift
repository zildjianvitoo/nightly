//
//  TomorrowPrep.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import Foundation

struct TomorrowPrep: Codable {
    var items: [PrepItem]
    var outfit: String
    var breakfast: String
    var notes: String
    var reminderEnabled: Bool
    var reminderTime: Date
}

extension TomorrowPrep {
    static let `default` = TomorrowPrep(
        items: PrepItem.defaultItems,
        outfit: "",
        breakfast: "",
        notes: "",
        reminderEnabled: false,
        reminderTime: Self.defaultReminderTime
    )

    private static var defaultReminderTime: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 20
        components.minute = 0

        return Calendar.current.date(from: components) ?? Date()
    }

    var sanitizedForPersistence: TomorrowPrep {
        var seenIDs = Set<UUID>()
        let cleanedItems = items.compactMap { item -> PrepItem? in
            let cleanedTitle = item.title.trimmed
            guard !cleanedTitle.isEmpty else {
                return nil
            }

            var sanitizedItem = item
            sanitizedItem.title = cleanedTitle

            if seenIDs.contains(sanitizedItem.id) {
                sanitizedItem = PrepItem(
                    title: cleanedTitle,
                    isChecked: sanitizedItem.isChecked,
                    isDefault: sanitizedItem.isDefault
                )
            }

            seenIDs.insert(sanitizedItem.id)
            return sanitizedItem
        }

        return TomorrowPrep(
            items: cleanedItems.isEmpty ? PrepItem.defaultItems : cleanedItems,
            outfit: outfit,
            breakfast: breakfast,
            notes: notes,
            reminderEnabled: reminderEnabled,
            reminderTime: reminderTime
        )
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
