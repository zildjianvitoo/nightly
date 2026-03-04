//
//  PrepStore.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import Combine
import Foundation

@MainActor
final class PrepStore: ObservableObject {
    enum ReadinessStatus: String {
        case notReady
        case almostReady
        case readyForTomorrow
    }

    private static let storageKey = "morning-prep-store-v2"
    private static let legacyStorageKey = "morning-prep-store"
    private static let lastAutoResetKey = "morning-prep-last-auto-reset"
    private static let autoResetHour = 8

    @Published var prep: TomorrowPrep {
        didSet {
            save()

            guard prep.reminderEnabled, Self.isFullyPrepared(prep) != Self.isFullyPrepared(oldValue) else {
                return
            }

            Task {
                _ = await applyReminder(enabled: true, time: prep.reminderTime)
            }
        }
    }

    private let defaults: UserDefaults
    private let notificationManager: NotificationManager
    private var morningResetTimer: Timer?

    convenience init() {
        self.init(defaults: .standard)
    }

    convenience init(defaults: UserDefaults) {
        self.init(defaults: defaults, notificationManager: .shared)
    }

    init(defaults: UserDefaults, notificationManager: NotificationManager) {
        self.defaults = defaults
        self.notificationManager = notificationManager
        self.prep = Self.loadPrep(from: defaults) ?? .default
    }

    var completionProgress: Double {
        guard totalRequiredSteps > 0 else {
            return 0
        }

        return Double(completedRequiredSteps) / Double(totalRequiredSteps)
    }

    var readinessStatus: ReadinessStatus {
        switch completionProgress {
        case ..<0.4:
            return .notReady
        case ..<0.9:
            return .almostReady
        default:
            return .readyForTomorrow
        }
    }

    var readinessTitle: String {
        switch readinessStatus {
        case .notReady:
            return "Not Ready Yet"
        case .almostReady:
            return "Almost Ready"
        case .readyForTomorrow:
            return "Ready for Tomorrow"
        }
    }

    var readinessMessage: String {
        switch readinessStatus {
        case .notReady:
            return "Take two minutes tonight and make tomorrow easier."
        case .almostReady:
            return "Just one or two things left before tomorrow starts smoothly."
        case .readyForTomorrow:
            return "Everything important is already lined up."
        }
    }

    var hasCheckedItem: Bool {
        prep.items.contains(where: \.isChecked)
    }

    var completedRequiredSteps: Int {
        checkedItemsCount
            + (prep.outfit.trimmed.isEmpty ? 0 : 1)
            + (prep.breakfast.trimmed.isEmpty ? 0 : 1)
    }

    var totalRequiredSteps: Int {
        prep.items.count + 2
    }

    var isFullyPrepared: Bool {
        Self.isFullyPrepared(prep)
    }

    private var checkedItemsCount: Int {
        prep.items.filter(\.isChecked).count
    }

    func toggleItem(_ item: PrepItem) {
        guard let index = prep.items.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        prep.items[index].isChecked.toggle()
    }

    @discardableResult
    func addItem(title: String) -> Bool {
        let cleanedTitle = title.trimmed
        guard !cleanedTitle.isEmpty else {
            return false
        }

        prep.items.append(PrepItem(title: cleanedTitle))
        return true
    }

    func removeItems(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            prep.items.remove(at: index)
        }
    }

    func resetForTomorrow() {
        prep.items = prep.items.map { item in
            var updatedItem = item
            updatedItem.isChecked = false
            return updatedItem
        }
        prep.outfit = ""
        prep.breakfast = ""
        prep.notes = ""
    }

    func refreshDailyPrepState(now: Date = Date()) {
        performMorningResetIfNeeded(now: now)
        scheduleNextMorningReset(from: now)
    }

    func updateOutfit(_ outfit: String) {
        prep.outfit = outfit
    }

    func updateBreakfast(_ breakfast: String) {
        prep.breakfast = breakfast
    }

    func updateNotes(_ notes: String) {
        prep.notes = notes
    }

    func updateReminder(enabled: Bool, time: Date) {
        prep.reminderEnabled = enabled
        prep.reminderTime = time
    }

    func applyReminder(enabled: Bool, time: Date) async -> NotificationManager.ReminderSyncResult? {
        let previousEnabled = prep.reminderEnabled
        let previousTime = prep.reminderTime

        prep.reminderTime = time

        do {
            let result = try await notificationManager.syncReminder(
                enabled: enabled,
                time: time,
                isFullyPrepared: isFullyPrepared
            )

            switch result {
            case .scheduled:
                prep.reminderEnabled = true
            case .disabled, .denied:
                prep.reminderEnabled = false
            }

            return result
        } catch {
            prep.reminderEnabled = previousEnabled
            prep.reminderTime = previousTime
            return nil
        }
    }

    func syncReminderSchedule() async {
        _ = await applyReminder(enabled: prep.reminderEnabled, time: prep.reminderTime)
    }

    deinit {
        morningResetTimer?.invalidate()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(prep) else {
            return
        }

        defaults.set(data, forKey: Self.storageKey)
    }

    private static func loadPrep(from defaults: UserDefaults) -> TomorrowPrep? {
        if let currentPrep = loadPrep(forKey: storageKey, from: defaults) {
            return currentPrep
        }

        guard let legacyPrep = loadPrep(forKey: legacyStorageKey, from: defaults) else {
            return nil
        }

        if let data = try? JSONEncoder().encode(legacyPrep) {
            defaults.set(data, forKey: storageKey)
        }

        defaults.removeObject(forKey: legacyStorageKey)
        return legacyPrep
    }

    private static func loadPrep(forKey key: String, from defaults: UserDefaults) -> TomorrowPrep? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        guard let decodedPrep = try? JSONDecoder().decode(TomorrowPrep.self, from: data) else {
            defaults.removeObject(forKey: key)
            return nil
        }

        let sanitizedPrep = decodedPrep.sanitizedForPersistence

        if let sanitizedData = try? JSONEncoder().encode(sanitizedPrep), sanitizedData != data {
            defaults.set(sanitizedData, forKey: key)
        }

        return sanitizedPrep
    }

    private func performMorningResetIfNeeded(now: Date) {
        guard let todayAutoResetTime = Self.autoResetTime(on: now), now >= todayAutoResetTime else {
            return
        }

        let lastAutoResetAt = defaults.object(forKey: Self.lastAutoResetKey) as? Date ?? .distantPast
        guard lastAutoResetAt < todayAutoResetTime else {
            return
        }

        resetForTomorrow()
        defaults.set(now, forKey: Self.lastAutoResetKey)
    }

    private func scheduleNextMorningReset(from now: Date) {
        morningResetTimer?.invalidate()

        guard let nextAutoResetTime = Self.nextAutoResetTime(after: now) else {
            return
        }

        let interval = nextAutoResetTime.timeIntervalSince(now)
        guard interval > 0 else {
            return
        }

        morningResetTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else {
                    return
                }

                self.refreshDailyPrepState()
            }
        }
    }

    private static func autoResetTime(on date: Date) -> Date? {
        Calendar.current.date(
            bySettingHour: autoResetHour,
            minute: 0,
            second: 0,
            of: date
        )
    }

    private static func nextAutoResetTime(after date: Date) -> Date? {
        guard let todayAutoResetTime = autoResetTime(on: date) else {
            return nil
        }

        if date < todayAutoResetTime {
            return todayAutoResetTime
        }

        return Calendar.current.date(byAdding: .day, value: 1, to: todayAutoResetTime)
    }

    private static func isFullyPrepared(_ prep: TomorrowPrep) -> Bool {
        let checkedItemsCount = prep.items.filter(\.isChecked).count
        let completedRequiredSteps =
            checkedItemsCount
            + (prep.outfit.trimmed.isEmpty ? 0 : 1)
            + (prep.breakfast.trimmed.isEmpty ? 0 : 1)
        let totalRequiredSteps = prep.items.count + 2

        guard totalRequiredSteps > 0 else {
            return false
        }

        return completedRequiredSteps >= totalRequiredSteps
    }
}

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
