//
//  NewsItemView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-05-28.
//

import SwiftUI

struct NewsItemView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("appLanguage") private var appLanguage = ""
    @State private var showingShareSheet = false
    @State private var selectedTicker: IdentifiableTicker?
    
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
           
            if let imageURL = newsItem.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .fixedSize(horizontal: false, vertical: true)
                        .clipped()
                        .mask(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                } placeholder: {
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .mask(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                }

            }
            HStack {
                if let logo = newsItem.source.logo {
                    if UIImage(systemName: logo) != nil {
                        Image(systemName: logo)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentColor)
                    } else {
                        if newsItem.source.name == "Nyheter" || newsItem.source.name.contains("- Nyheter") || newsItem.source.name.contains("Händelser") || newsItem.source.name.contains("Pressmeddelanden") || newsItem.source.name.contains("politidistrikt") || newsItem.source.name == ("Nasjonale nyheter") || newsItem.source.name == ("Utrykningspolitiet") || newsItem.source.name.contains("poliisi") || newsItem.source.name.contains("Poliisi") {
                            Image(logo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 30)
                        } else {
                            Image(logo)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        }
                    }
                }
                Text(newsItem.source.name)
                    .font(.headline)
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 5)
            
            Text(newsItem.title)
                .font(.title2)
                .bold()
                .padding(.horizontal)
                .padding(.bottom, 5)
                .padding(.top, 5)

            Text(newsItem.description)
                .font(.body)
                .lineLimit(5)
                .padding(.horizontal)
                .padding(.bottom, 5)
            
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
                }
                .padding(.horizontal)
            }
            
            HStack{
                if newsItem.source.name == "Nyheter" || newsItem.source.name.contains("- Nyheter") || newsItem.source.name.contains("Händelser") || newsItem.source.name.contains("Pressmeddelanden") || newsItem.source.name.contains("politidistrikt") || newsItem.source.name == ("Nasjonale nyheter") || newsItem.source.name == ("Utrykningspolitiet") || newsItem.source.name.contains("poliisi") || newsItem.source.name.contains("Poliisi") {
                    Text(String(format: StringManager.shared.get("artikelfrån2"), newsItem.source.name))
                } else {
                    Text(String(format: StringManager.shared.get("artikelfrån"), newsItem.source.name))
                }
                Spacer()
                
                if let date = newsItem.pubDate {
                    Text(dateFormatted(date))
                }
            }
            .padding([.horizontal, .bottom])
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isDarkMode ? Color.gray.opacity(0.15) : Color(white: 0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isDarkMode ? Color.gray.opacity(0.5) : Color.black, lineWidth: 1)
                )
        )
        .padding(.top, 10)
        .contextMenu {
            Button {
                showingShareSheet = true
            } label: {
                Label(StringManager.shared.get("delaartikel"), systemImage: "square.and.arrow.up")
            }
            Button {
                    if let url = newsItem.link {
                        UIPasteboard.general.string = url.absoluteString
                    }
                } label: {
                    Label(StringManager.shared.get("kopieralänk"), systemImage: "doc.on.doc")
            }
        }
        .sheet(item: $selectedTicker) { wrapper in
            StockChartView(symbol: wrapper.symbol)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = newsItem.link {
                ShareSheet(activityItems: [url])
                    .presentationDetents([.medium])
            }
        }
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = appLanguage == "en" ? Locale(identifier: "en_US") : Locale(identifier: "sv_SE")
        return formatter.string(from: date)
    }

    struct RoundedCorner: Shape {
        var radius: CGFloat = 10
        var corners: UIRectCorner = [.topLeft, .topRight]

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
}

