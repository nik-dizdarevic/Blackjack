//
//  HandView.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 07/05/2022.
//

import SwiftUI

struct HandView: View {
    
    var namespace: Namespace.ID
    let hand: Game.Hand
    let state: Game.EndState?
    
    var body: some View {
        VStack {
            stackedCards
                .aspectRatio(2/3, contentMode: .fit)
            betAmount
        }
    }
    
    var stackedCards: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                ForEach(hand.cards) { card in
                    if let i = hand.cards.firstIndex(of: card) {
                        CardView(card: card)
                            .matchedGeometryEffect(id: card.id, in: namespace)
                            .offset(x: i > 0 ? cardOffset(in: geometry.size, for: i) : 0)
                            .transition(.asymmetric(insertion: .offset(x: 500, y: -500), removal: .identity))
                    }
                }
                if hand.cards.count > 1 {
                    Text("\(hand.score())")
                        .background(
                            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                                .frame(width: frame(for: geometry.size), height: frame(for: geometry.size))
                                .foregroundColor(.white)
                        )
                        .font(font(in: geometry.size).bold())
                        .offset(x: scoreOffset(in: geometry.size, for: hand.cards.count - 1))
                }
            }
            .offset(x: -handOffset(in: geometry.size, for: hand.cards.count - 1))
            .overlay(endState, alignment: .center)
        }
    }
    
    @ViewBuilder
    var endState: some View {
        let roundedRectange =  RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            .foregroundColor(.cardBackground)
            .shadow(radius: 5)
       
        switch state {
        case .playerWins:
            if hand.bet != nil {
                ZStack {
                    roundedRectange
                    Text("You Win")
                }
                .transition(.scale)
            }
        case .dealerWins:
            if hand.bet == nil {
                ZStack {
                    roundedRectange
                    Text("Dealer Wins")
                }
                .transition(.scale)
            }
        case .push:
            ZStack {
                roundedRectange
                Text("Push")
            }
            .transition(.scale)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var betAmount: some View {
        if let bet = hand.bet {
            Text("Bet: $\(bet, specifier: "%.2f")")
                .padding()
        } else {
            Text("Bet: $0")
                .opacity(0)
                .padding()
        }
    }
    
    private func cardOffset(in size: CGSize, for index: Int) -> CGFloat {
        size.width * DrawingConstants.offsetPercentage * CGFloat(index)
    }
    
    private func scoreOffset(in size: CGSize, for cardCount: Int) -> CGFloat {
        size.width * DrawingConstants.offsetPercentage * CGFloat(cardCount)
    }
    
    private func handOffset(in size: CGSize, for cardCount: Int) -> CGFloat {
        let newCenterX = (size.width + size.width * DrawingConstants.offsetPercentage) / 2
        let oldCenterX = size.width / 2
        let diff = newCenterX - oldCenterX
        return diff * CGFloat(cardCount)
    }
    
    private func font(in size: CGSize) -> Font {
        .system(size: size.width * DrawingConstants.fontScale)
    }
    
    private func frame(for size: CGSize) -> CGFloat {
        size.width * DrawingConstants.framePercentage
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let offsetPercentage: CGFloat = 0.7
        static let fontScale: CGFloat = 0.1
        static let framePercentage: CGFloat = 0.3
    }
    
}

struct HandView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        let game = BlackjackGame()
        let _ = game.placeBet(50)
        let _ = game.dealOneToPlayer()
        let _ = game.dealOneToPlayer()
        HandView(namespace: namespace, hand: game.playerHands[0], state: .playerWins)
    }
}
