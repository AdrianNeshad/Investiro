//
//  TickerScrollView.swift
//  Unifeed
//
//  Created by Adrian Neshad on 2025-07-08.
//

import SwiftUI

struct TickerScrollerView: View {
    let tickers: [TickerData]
    var onSelect: ((IdentifiableTicker) -> Void)? = nil

    @State private var offset: CGFloat = 0
    private let itemWidth: CGFloat = 110
    private let spacing: CGFloat = 20
    private let speed: CGFloat = 0.5 // adjust to control scroll speed

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { context in
                HStack(spacing: spacing) {
                    ForEach(tickers + tickers, id: \.id) { ticker in
                        TickerView(ticker: ticker)
                            .frame(width: itemWidth)
                            .onTapGesture {
                                onSelect?(IdentifiableTicker(symbol: ticker.symbol))
                            }
                    }
                }
                .offset(x: -offset)
                .onAppear {
                    offset = 0
                }
                .onChange(of: context.date) {
                    let totalWidth = CGFloat(tickers.count) * (itemWidth + spacing)
                    offset += speed
                    if offset >= totalWidth {
                        offset = 0
                    }
                }
                .frame(width: geo.size.width, alignment: .leading)
                .clipped()
            }
        }
        .frame(height: 60)
    }
}
