//
//  NotificationManager.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import Foundation
import UserNotifications

actor NotificationManager {
    enum ReminderSyncResult {
        case scheduled
        case disabled
        case denied
    }

    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let reminderIdentifier = "morning-prep-nightly-reminder"

    func syncReminder(enabled: Bool, time: Date) async throws -> ReminderSyncResult {
        guard enabled else {
            cancelNightlyReminder()
            return .disabled
        }

        let isAuthorized = try await requestPermission()
        guard isAuthorized else {
            cancelNightlyReminder()
            return .denied
        }

        try await scheduleNightlyReminder(at: time)
        return .scheduled
    }

    func requestPermission() async throws -> Bool {
        let settings = await notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .notDetermined:
            return try await requestAuthorization()
        case .denied:
            return false
        @unknown default:
            return false
        }
    }

    func scheduleNightlyReminder(at time: Date) async throws {
        cancelNightlyReminder()

        let content = UNMutableNotificationContent()
        content.title = "Prepare for tomorrow"
        content.body = "Take a minute to set out what you need for the morning."
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: reminderIdentifier,
            content: content,
            trigger: trigger
        )

        try await add(request)
    }

    func cancelNightlyReminder() {
        center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
    }

    private func requestAuthorization() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: granted)
            }
        }
    }

    private func add(_ request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            center.add(request) { error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: ())
            }
        }
    }

    private func notificationSettings() async -> UNNotificationSettings {
        await withCheckedContinuation { continuation in
            center.getNotificationSettings { settings in
                continuation.resume(returning: settings)
            }
        }
    }
}
