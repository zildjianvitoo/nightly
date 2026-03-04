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
    @State private var showSplash = true  // Flag for splash screen

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(store)
                    .opacity(showSplash ? 0 : 1)
                    .task {
                        store.refreshDailyPrepState()
                        await store.syncReminderSchedule()
                    }
                    .onChange(of: scenePhase) { _, newPhase in
                        guard newPhase == .active else { return }
                        store.refreshDailyPrepState()
                    }

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Automatically hide splash screen after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
