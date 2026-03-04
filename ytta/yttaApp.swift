//
//  yttaApp.swift
//  ytta
//
//  Created by Academy on 03/03/26.
//

import SwiftUI

@main
struct yttaApp: App {
    @StateObject private var store = PrepStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    await store.syncReminderSchedule()
                }
        }
    }
}
