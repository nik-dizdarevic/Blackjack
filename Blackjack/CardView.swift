//
//  CardView.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 04/05/2022.
//

import SwiftUI

struct CardView: View {
    let card: Game.Card
    
    var body: some View {
        cardContent
            .cardify(isFaceUp: card.isFaceUp, color: card.suit == .diamonds || card.suit == .hearts ? .cardRed : .cardGrey)
    }
    
    var cardContent: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text(card.rank.rawValue)
                    Spacer()
                    Image(systemName: card.suit.rawValue)
                }
                .padding(padding(in: geometry.size))
                .font(font(in: geometry.size).weight(.bold))
                Spacer()
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: size.width * DrawingConstants.fontScale)
    }
    
    private func padding(in size: CGSize) -> CGFloat {
        size.width * DrawingConstants.paddingPercentage
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.25
        static let paddingPercentage: CGFloat = 0.2
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Game.Card(id: 0, suit: .spades, rank: .eight, isFaceUp: true))
//        CardView(card: Game.Card(id: 0, suit: .hearts, rank: .queen, isFaceUp: true))
//        CardView(card: Game.Card(id: 0, suit: .diamonds, rank: .ten, isFaceUp: true))
//        CardView(card: Game.Card(id: 0, suit: .clubs, rank: .five, isFaceUp: true))
//        CardView(card: Game.Card(id: 0, suit: .spades, rank: .eight, isFaceUp: true)).previewDevice("iPad Pro (9.7-inch)")
    }
}
