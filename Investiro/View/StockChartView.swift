//
//  StockChartView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-07-08.
//

import SwiftUI

struct StockChartView: View {
    let symbol: String
    @State private var prices: [Double] = []
    @State private var timestamps: [Int] = []
    @State private var currentPrice: Double?
    @State private var percentageChange: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Rubrik & pris
            HStack {
                VStack(alignment: .leading) {
                    Text(symbol.uppercased())
                        .font(.title2)
                        .bold()
                    HStack {
                        if let price = currentPrice {
                            Text(String(format: "%.2f", price))
                                .foregroundColor(.white)
                        }
                        if let change = percentageChange {
                            Text(String(format: "%@", formattedPercentage(change)))
                                .foregroundColor(change >= 0 ? .green : .red)
                        }
                        Text("YTD")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            // Kursgraf
            if prices.isEmpty {
                ProgressView().frame(height: 220)
            } else {
                ChartWithXAxis(prices: prices, timestamps: timestamps)
                    .frame(height: 220)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .padding(.top)
        .background(Color.black)
        .foregroundColor(.white)
        .onAppear {
            fetchYahooChart(symbol: symbol)
        }
    }

    private func formattedPercentage(_ change: Double) -> String {
        String(format: "%@%.2f%%", change >= 0 ? "+" : "", change)
    }

    private func fetchYahooChart(symbol: String) {
        // Endast Year-To-Date
        let url = URL(string: "https://query2.finance.yahoo.com/v8/finance/chart/\(symbol)?interval=1d&range=ytd")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let chart = (json["chart"] as? [String: Any])?["result"] as? [[String: Any]],
                  let result = chart.first,
                  let indicators = (result["indicators"] as? [String: Any])?["quote"] as? [[String: Any]],
                  let closes = indicators.first?["close"] as? [Double],
                  let timestamps = result["timestamp"] as? [Int] else {
                return
            }

            let validPairs = zip(closes, timestamps).filter { !$0.0.isNaN }

            DispatchQueue.main.async {
                self.prices = validPairs.map { $0.0 }
                self.timestamps = validPairs.map { $0.1 }
                self.currentPrice = self.prices.last
                if let first = self.prices.first, let last = self.prices.last {
                    self.percentageChange = ((last - first) / first) * 100
                }
            }
        }.resume()
    }
}

private func InfoLabel(_ title: String, value: Double?) -> some View {
    VStack(alignment: .leading, spacing: 1) {
        Text(title).font(.caption).foregroundColor(.gray)
        if let v = value {
            Text(String(format: "%.2f", v)).font(.caption2)
        } else {
            Text("–").font(.caption2)
        }
    }
}
