//
//  Filter.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-30.
//

import SwiftUI

struct Filter: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: FeedViewModel
    @AppStorage("appLanguage") private var appLanguage = ""
    @State private var showingAddSource = false

    var body: some View {
        List {
            
            if let custom = viewModel.currentCustomCategory {
                ForEach(viewModel.customCategorySources[custom.id] ?? []) { source in
                    sourceRow(source)
                        .swipeActions {
                            Button(role: .destructive) {
                                removeCustomCategorySource(source, for: custom)
                            } label: {
                                Label(StringManager.shared.get("radera"), systemImage: "trash")
                            }
                        }
                }

                Section {
                    Button {
                        showingAddSource = true
                    } label: {
                        Label(StringManager.shared.get("läggtillegen"), systemImage: "plus")
                    }
                }

            } else {
                ForEach(viewModel.currentCategory.sources) { source in
                    sourceRow(source)
                }

                if viewModel.currentCategory != .polisen {
                    Section(header: Text(StringManager.shared.get("egnakällor"))) {
                        ForEach(viewModel.customSources[viewModel.currentCategory] ?? []) { source in
                            sourceRow(source)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        removeCustomSource(source)
                                    } label: {
                                        Label(StringManager.shared.get("radera"), systemImage: "trash")
                                    }
                                }
                        }
                        Button {
                            showingAddSource = true
                        } label: {
                            Label(StringManager.shared.get("läggtillegen"), systemImage: "plus")
                        }
                    }
                }
            }
        }
        .navigationTitle(StringManager.shared.get("väljkällor"))
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(StringManager.shared.get("klar")) {
                    viewModel.loadNews()
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingAddSource) {
            NavigationView {
                AddCustomSourceView(category: viewModel.currentCategory, customCategory: viewModel.currentCustomCategory)
                    .environmentObject(viewModel)
            }
        }
    }

    private func sourceRow(_ source: NewsSource) -> some View {
        Button {
            toggle(source)
        } label: {
            HStack {
                if let logo = source.logo {
                    if UIImage(systemName: logo) != nil {
                        Image(systemName: logo)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentColor)
                    } else {
                        Image(logo) 
                            .resizable()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                } else {
                    Image(systemName: source.isCustom ? "swift" : "photo")
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
                Text(source.name)
                    .padding(.leading, 4)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: viewModel.activeSources.contains(source.name) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.accentColor)
            }
        }
    }

    private func toggle(_ source: NewsSource) {
        if viewModel.activeSources.contains(source.name) {
            viewModel.activeSources.remove(source.name)
        } else {
            viewModel.activeSources.insert(source.name)
        }
    }

    private func removeCustomSource(_ source: NewsSource) {
        viewModel.customSources[viewModel.currentCategory]?.removeAll { $0.id == source.id }
        viewModel.activeSources.remove(source.name)
    }

    private func removeCustomCategorySource(_ source: NewsSource, for category: CustomCategory) {
        viewModel.customCategorySources[category.id]?.removeAll { $0.id == source.id }
        viewModel.activeSources.remove(source.name)
    }
}
