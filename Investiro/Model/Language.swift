//
//  Language.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI

class StringManager {
    static let shared = StringManager()
    @AppStorage("appLanguage") var language: String = "en"
    
    private let en: [String: String] = [
        "feed": "Feed",
        "settings": "Settings",
        "language": "Language",
        "darkmode": "Dark Mode",
        "general": "General",
        "about": "About",
        "rate": "Rate",
        "shareapp": "Share app",
        "checkin": "Check in",
        "givefeedback": "Give feedback",
        "otherapps": "Other apps",
        
    ]

    private let sv: [String: String] = [
        "feed": "Flöde",
        "settings": "Inställningar",
        "language": "Språk",
        "darkmode": "Mörkt läge",
        "general": "Allmänt",
        "about": "Om",
        "rate": "Betygsätt",
        "shareapp": "Dela appen",
        "checkin": "Kolla in",
        "givefeedback": "Ge feedback",
        "otherapps": "Andra appar",
        
        
    ]
    
    private var tables: [String: [String: String]] {
        [
            "sv": sv, // Svenska
            "en": en, // Engelska
        ]
    }

    func get(_ key: String) -> String {
        tables[language]?[key] ?? key
    }
}
