//
//  yttaApp.swift
//  ytta
//
//  Created by Academy on 03/03/26.
//

import SwiftUI

@main
struct yttaApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var store = PrepStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    store.refreshDailyPrepState()
                    await store.syncReminderSchedule()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    guard newPhase == .active else {
                        return
                    }

                    store.refreshDailyPrepState()
                }
        }
    }
}
