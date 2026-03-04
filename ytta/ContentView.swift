//
//  ContentView.swift
//  ytta
//
//  Created by Academy on 03/03/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            PrepHomeView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                        }
                        .accessibilityLabel("Open settings")
                    }
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
