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
    
    @State private var pendingNewsItem: NewsItem? = nil
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(StringManager.shared.get("feed"), systemImage: "newspaper", value: 0) {
                IndexView()
                    .environmentObject(viewModel)
            }
            Tab(StringManager.shared.get("settings"), systemImage: "gear", value: 1) {
                SettingsView()
            }
            Tab(StringManager.shared.get("search"), systemImage: "magnifyingglass", value: 2, role: .search) {
                   SearchView()
                    .navigationTitle(StringManager.shared.get("search"))
            }
        }
    }
}

#Preview {
    MainTabView()
}
