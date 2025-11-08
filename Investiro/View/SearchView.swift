//
//  SearchView.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @AppStorage("darkMode") private var darkMode = true
    @AppStorage("appLanguage") private var appLanguage = "en"
    
    private let items = [
        "Adrian",
        "Kalle",
        "Gustav",
        "Erik",
        "Oskar",
        "Johan"
    ]
    
    private var filteredItems: [String] {
        if searchText.isEmpty { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(searchText)}
    }
    
    var body: some View {
        NavigationStack {
            List(filteredItems, id: \.self) { item in
                Text(item)
            }
            .navigationTitle(StringManager.shared.get("search"))
        }
        .searchable(text: $searchText)
    }
}
