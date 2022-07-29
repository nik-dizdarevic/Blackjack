//
//  ChipView.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 07/05/2022.
//

import SwiftUI

struct ChipView: View {
    
    let bet: Game.Bet
    
    var body: some View {
        GeometryReader { geometry in
            let shape = Circle()
            ZStack {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: DrawingConstants.outerLineWidth)
                shape
                    .strokeBorder(style: middleLineStyle(in: geometry.size))
                shape
                    .strokeBorder(lineWidth: DrawingConstants.innerLineWidth)
                    .scaleEffect(1 - DrawingConstants.radiusPercentage)
                Text("\(bet.rawValue)")
                    .font(font(in: geometry.size).bold())
            }
            .foregroundColor(.chipBackground)
        }
    }
    
    private func middleLineWidth(in size: CGSize) -> CGFloat {
        let radius = min(size.width, size.height) / 2
        return radius * DrawingConstants.radiusPercentage
    }
    
    private func middleLineStyle(in size: CGSize) -> StrokeStyle {
        StrokeStyle(lineWidth: middleLineWidth(in: size), dash: DrawingConstants.dash)
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let radiusPercentage: CGFloat = 0.25
        static let fontScale: CGFloat = 0.3
        static let dash: [CGFloat] = [15]
        static let innerLineWidth: CGFloat = 5
        static let outerLineWidth: CGFloat = 2
    }
}

struct ChipsView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView(bet: .oneHundred)
    }
}
