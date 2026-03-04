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

    func syncReminder(enabled: Bool, time: Date, isFullyPrepared: Bool) async throws -> ReminderSyncResult {
        guard enabled else {
            cancelNightlyReminder()
            return .disabled
        }

        let isAuthorized = try await requestPermission()
        guard isAuthorized else {
            cancelNightlyReminder()
            return .denied
        }

        try await scheduleNightlyReminder(at: time, isFullyPrepared: isFullyPrepared)
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

    func scheduleNightlyReminder(at time: Date, isFullyPrepared: Bool) async throws {
        cancelNightlyReminder()

        let content = UNMutableNotificationContent()
        if isFullyPrepared {
            content.title = "Tomorrow is set"
            content.body = "Nice work. Everything is ready, so you can wind down for the night."
        } else {
            content.title = "Prepare for tomorrow"
            content.body = "You are not fully ready yet. Take a minute to set out what you need."
        }
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
