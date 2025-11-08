//
//  ChartWithAxis.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-07-09.
//

import SwiftUI

struct ChartWithXAxis: View {
    var prices: [Double]
    var timestamps: [Int]

    var body: some View {
        VStack(spacing: 4) {
            LineChart(data: prices, color: .green)
                .frame(height: 180)

            // Datumetiketter på X-axeln
            HStack {
                if let first = timestamps.first,
                   let last = timestamps.last {
                    Text(formatDate(first))
                    Spacer()
                    Text(formatDate(last))
                }
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
    }

    func formatDate(_ unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
}
