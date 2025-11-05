//
//  AppVersion.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-05.
//

import SwiftUI

struct AppVersion: View {
    var body: some View {
        Section {
            EmptyView()
        } footer: {
            VStack(spacing: 4) {
                Text("© 2025 Investiro App")
                Text("Github.com/AdrianNeshad")
                Text("Linkedin.com/in/adrian-neshad")
            }
            .font(.caption)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
