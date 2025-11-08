//
//  InvestiroIndex.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-02.
//

import SwiftUI
import AlertToast

struct IndexView: View {
    @AppStorage("darkMode") private var darkMode = true
    @AppStorage("appLanguage") private var appLanguage = "en"
    @StateObject var viewModel = FeedViewModel()
    @State private var selectedNewsItem: NewsItem? = nil
    @State private var showingCategoryPicker = false
    @State private var showFeedUpdatedToast = false
    @State private var wasLoading = false
    @State private var showingFilterSheet = false
    @State private var showingAddCategory = false
    @State private var featuredData: [TickerData] = []
    @State private var selectedTicker: IdentifiableTicker?
    
    var featuredTickers: [String] {
        if appLanguage == "sv" {
            return ["^OMX", "^GSPC", "^NDX", "^DJI", "^STOXX50E", "^GDAXI", "^FTSE", "^N225"]
        } else if appLanguage == "no" {
            return ["^OSEAX", "OBX.OL", "^GSPC", "^NDX", "^DJI", "^STOXX50E", "^GDAXI", "^FTSE"]
        } else if appLanguage == "fi" {
            return ["^OMXH25", "^GSPC", "^NDX", "^DJI", "^STOXX50E", "^GDAXI", "^FTSE"]
        } else {
            return ["^GSPC", "^NDX", "^DJI", "^STOXX50E", "^FTSE", "^N225"]
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if !featuredData.isEmpty {
                        TickerScrollerView(tickers: featuredData) { selected in
                            selectedTicker = selected
                        }
                        .padding(.bottom, 25)
                        .padding(.horizontal)
                    }
                    LazyVStack {
                        if viewModel.isLoading {
                            VStack(spacing: 8) {
                                ProgressView()
                                    .padding(.top, 20)
                                    .scaleEffect(1.75)
                                Text(StringManager.shared.get("laddar"))
                                    .font(.body)
                                    .padding(.top, 20)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                        } else {
                            ForEach(Array(viewModel.partialItems.enumerated()), id: \.element.id) { index, item in
                                NewsItemView(newsItem: item)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedNewsItem = item
                                }                            }
                        }
                    }
                }
            }
            .onAppear {
                if featuredData.isEmpty {
                    for symbol in featuredTickers {
                        fetchTickerData(for: symbol) { data in
                            if let data = data {
                                DispatchQueue.main.async {
                                    featuredData.append(data)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(StringManager.shared.get("feed"))
            .sheet(item: $selectedTicker) { wrapper in
                StockChartView(symbol: wrapper.symbol)
                    .presentationDetents([.medium])
            }
            .refreshable {
                viewModel.loadNews()
            }
            .preferredColorScheme(darkMode ? .dark : .light)
        }
        .sheet(item: $selectedNewsItem) { item in
            ArticleDetailView(newsItem: item)
                .environmentObject(viewModel)
        }
    }
}
