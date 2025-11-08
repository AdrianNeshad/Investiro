//
//  CustomCategory.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import Foundation

struct CustomCategory: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let icon: String

    init(name: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
}
