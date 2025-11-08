//
//  ArticleDetailView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-06-19.
//

import SwiftUI

struct ArticleDetailView: View {
    let newsItem: NewsItem
    @EnvironmentObject var viewModel: FeedViewModel
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("appLanguage") private var appLanguage = ""
    @Environment(\.dismiss) var dismiss
    @State private var selectedLink: IdentifiableURL? = nil
    @State private var showingShareSheet = false
    @State private var showPolitiloggen = false
    @State private var selectedTicker: IdentifiableTicker?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if let imageURL = newsItem.imageURL {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }

                    Text(newsItem.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                    
                    HStack {
                        if let logo = newsItem.source.logo {
                            if UIImage(systemName: logo) != nil {
                                Image(systemName: logo)
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.accentColor)
                            } else {
                                if newsItem.source.name == "Nyheter" || newsItem.source.name.contains("- Nyheter") || newsItem.source.name.contains("Händelser") || newsItem.source.name.contains("Pressmeddelanden") || newsItem.source.name.contains("politidistrikt") || newsItem.source.name == ("Nasjonale nyheter") || newsItem.source.name == ("Utrykningspolitiet") || newsItem.source.name.contains("poliisi") || newsItem.source.name.contains("Poliisi") {
                                    Image(logo)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 25)
                                } else {
                                    Image(logo)
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Text(newsItem.source.name)
                            .font(.subheadline)
                        if let date = newsItem.pubDate {
                            Text("— \(dateFormatted(date))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    if newsItem.source.name == "Nyheter" || newsItem.source.name.contains("- Nyheter") || newsItem.source.name.contains("Händelser") || newsItem.source.name.contains("Pressmeddelanden") || newsItem.source.name.contains("politidistrikt") || newsItem.source.name == ("Nasjonale nyheter") || newsItem.source.name == ("Utrykningspolitiet") || newsItem.source.name.contains("poliisi") || newsItem.source.name.contains("Poliisi") {
                        Text(StringManager.shared.get("källa:polis"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    Text(newsItem.description)
                        .font(.body)
                        .padding(.horizontal)
                    
                    if !newsItem.tickers.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(newsItem.tickers, id: \.self) { ticker in
                                    Button(action: {
                                        selectedTicker = IdentifiableTicker(symbol: ticker)
                                    }) {
                                        Text(ticker)
                                            .padding(8)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                                        
                    if let link = newsItem.link {
                        VStack {
                            HStack {
                                Button {
                                    self.selectedLink = IdentifiableURL(url: link)
                                } label: {
                                    Label(StringManager.shared.get("originalartikel"), systemImage: "globe")
                                        .font(.callout)
                                        .padding(8)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                Button {
                                    showingShareSheet = true
                                } label: {
                                    Label(StringManager.shared.get("delaartikel"), systemImage: "square.and.arrow.up")
                                        .font(.callout)
                                        .padding(8)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.top, 1)
                            if newsItem.source.name.contains("politidistrikt") || newsItem.source.name == "Nasjonale nyheter" || newsItem.source.name == "Utrykningspolitiet" {
                                Button {
                                    showPolitiloggen = true
                                } label: {
                                    Label("Politiloggen", systemImage: "globe")
                                        .font(.callout)
                                        .padding(8)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            }
                        }
                    }
                    if newsItem.source.name == "Nyheter" || newsItem.source.name.contains("- Nyheter") || newsItem.source.name.contains("Händelser") || newsItem.source.name.contains("Pressmeddelanden") || newsItem.source.name.contains("politidistrikt") || newsItem.source.name == ("Nasjonale nyheter") || newsItem.source.name == ("Utrykningspolitiet") || newsItem.source.name.contains("poliisi") || newsItem.source.name.contains("Poliisi") {
                        Text(String(format: StringManager.shared.get("artikelinfo2"), newsItem.source.name))
                            .padding([.horizontal, .bottom])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text(String(format: StringManager.shared.get("artikelinfo"), newsItem.source.name))
                            .padding([.horizontal, .bottom])
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
            .sheet(item: $selectedTicker) { wrapper in
                StockChartView(symbol: wrapper.symbol)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showPolitiloggen) {
                SafariView(url: URL(string: "https://www.politiet.no/politiloggen")!)
            }
            .sheet(isPresented: $showingShareSheet) {
                if let url = newsItem.link {
                    ShareSheet(activityItems: [url])
                        .presentationDetents([.medium])
                }
            }
            .sheet(item: $selectedLink) { wrapped in
                SafariView(url: wrapped.url)
            }
            .navigationTitle(newsItem.source.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(StringManager.shared.get("klar")) {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = appLanguage == "en" ? Locale(identifier: "en_US") : Locale(identifier: "sv_SE")
        return formatter.string(from: date)
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}
