//
//  ContentView.swift
//  ytta
//
//  Created by Academy on 03/03/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedInitialReminderSetup") private var hasCompletedInitialReminderSetup = false
    @State private var showInitialReminderSetup = false

    var body: some View {
        NavigationStack {
            PrepHomeView()
        }
        .tint(AppTheme.accent)
        .onAppear {
            if !hasCompletedInitialReminderSetup {
                showInitialReminderSetup = true
            }
        }
        .fullScreenCover(isPresented: $showInitialReminderSetup) {
            NavigationStack {
                SettingsView(
                    isInitialSetup: true,
                    onInitialSetupCompleted: {
                        hasCompletedInitialReminderSetup = true
                        showInitialReminderSetup = false
                    }
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PrepStore())
    }
}
