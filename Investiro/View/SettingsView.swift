//
//  Settings.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = true
    @AppStorage("appLanguage") private var appLanguage = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .preferredColorScheme(darkMode ? .dark : .light)
    }
}
