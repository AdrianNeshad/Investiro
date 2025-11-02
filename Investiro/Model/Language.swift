//
//  Language.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI

class StringManager {
    static let shared = StringManager()
    @AppStorage("appLanguage") var language: String = ""
    
    private let en: [String: String] = [
        "feed": "Feed",
        "settings": "Settings",
        
    ]

    private let sv: [String: String] = [
        "feed": "Flöde",
        "settings": "Inställningar",
        
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
