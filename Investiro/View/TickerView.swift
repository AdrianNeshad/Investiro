//
//  TickerView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-07-08.
//

import SwiftUI

struct TickerData: Identifiable {
    let id = UUID()
    let symbol: String
    let currentPrice: Double
    let priceChange: Double
    let changePercent: Double
    let prices: [Double]
    
    var isUp: Bool {
        priceChange >= 0
    }
}

let tickerDisplayNames: [String: String] = [
    "^OMX": "OMXS30",
    "^GSPC": "S&P 500",
    "^NDX": "Nasdaq 100",
    "^DJI": "Dow Jones",
    "^STOXX50E": "Euro Stoxx 50",
    "^GDAXI": "DAX",
    "^FTSE": "FTSE 100",
    "^N225": "Nikkei 225",
    "^OSEAX": "OSEAX",
    "OBX.OL": "OBX",
    "^OMXH25": "OMX Helsinki 25",
]

struct TickerView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    let ticker: TickerData

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(tickerDisplayNames[ticker.symbol] ?? ticker.symbol)
                    .font(.caption)
                    .bold()
                Text("YTD")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            LineChart(data: ticker.prices, color: ticker.isUp ? .green : .red)
                .frame(height: 24)
            
            Text(String(format: "%.2f", ticker.currentPrice))
                .font(.caption2)
                .bold()

            Text(String(format: "%+.2f (%.2f%%)", ticker.priceChange, ticker.changePercent))
                .font(.caption2)
                .foregroundColor(ticker.isUp ? .green : .red)
        }
        .padding(6)
        .frame(width: 120, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isDarkMode ? Color.gray.opacity(0.15) : Color(white: 0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isDarkMode ? Color.gray.opacity(0.5) : Color.black, lineWidth: 1)
                )
        )
    }
}
