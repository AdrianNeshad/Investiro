//
//  ContentView.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @AppStorage("darkMode") private var darkMode = true
    @AppStorage("appLanguage") private var appLanguage = "en"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(StringManager.shared.get("feed", systemImage: "newspaper") {
                IndexView()
            }
            Tab(StringManager.shared.get("settings"), systemImage: "gear") {
                SettingsView()
            }
        }
        /*
         IndexView()
         .tabItem {
         Label(StringManager.shared.get("feed"), systemImage: "newspaper")
         }
         .tag(0)
         SettingsView()
         .tabItem {
         Label(StringManager.shared.get("settings"), systemImage: "gear")
         }
         }
         .preferredColorScheme(darkMode ? .dark : .light)
         }
         */
    }
}

#Preview {
    MainTabView()
}
