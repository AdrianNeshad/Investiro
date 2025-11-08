//
//  FetchTicker.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import Foundation

func fetchTickerData(for symbol: String, completion: @escaping (TickerData?) -> Void) {
    let urlStr = "https://query2.finance.yahoo.com/v8/finance/chart/\(symbol)?interval=1d&range=ytd"
    guard let url = URL(string: urlStr) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, _ in
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let chart = (json["chart"] as? [String: Any])?["result"] as? [[String: Any]],
              let result = chart.first,
              let indicators = (result["indicators"] as? [String: Any])?["quote"] as? [[String: Any]],
              let closes = indicators.first?["close"] as? [Double] else {
            completion(nil)
            return
        }

        let validPrices = closes.filter { !$0.isNaN }

        guard let first = validPrices.first,
              let last = validPrices.last else {
            completion(nil)
            return
        }

        let priceChange = last - first
        let percentChange = (priceChange / first) * 100

        completion(TickerData(
            symbol: symbol,
            currentPrice: last,
            priceChange: priceChange,
            changePercent: percentChange,
            prices: validPrices
        ))
    }.resume()
}
