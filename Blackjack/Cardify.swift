//
//  Cardify.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 06/05/2022.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    let color: Color
    
    // in degrees
    private var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool, color: Color) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape
                    .fill()
                    .foregroundColor(color)
                shape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                content
            } else {
                shape
                    .fill()
                    .foregroundColor(.cardBackground)
                shape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
            }
        }
        .foregroundColor(.white)
        .rotation3DEffect(Angle(degrees: rotation), axis: (0, 1, 0))
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 10
    }
    
}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
