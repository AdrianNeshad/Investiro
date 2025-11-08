//
//  LineChart.swift
//  Investiro
//
//  Created by Adrian Neshad on 2025-11-08.
//

import SwiftUI

struct LineChart: View {
    var data: [Double]
    var color: Color = .green

    var body: some View {
        GeometryReader { geometry in
            let maxY = data.max() ?? 1
            let minY = data.min() ?? 0
            let height = geometry.size.height
            let width = geometry.size.width
            let stepX = width / CGFloat(max(data.count - 1, 1))
            let color = (data.last ?? 0) < (data.first ?? 0) ? .red : color

            let points = data.enumerated().map { index, value in
                CGPoint(
                    x: CGFloat(index) * stepX,
                    y: height - CGFloat((value - minY) / (maxY - minY)) * height
                )
            }

            Path { path in
                guard let first = points.first else { return }
                path.move(to: first)
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
            }
            .stroke(color, lineWidth: 2)
        }
        .clipped()
    }
}
