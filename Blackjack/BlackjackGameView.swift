//
//  BlackjackGameView.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 03/05/2022.
//

import SwiftUI

// TODO: Handle iPhone landscape, Dark Mode, iPad, handle insufficient funds better, handle blackjack better, etc.
struct BlackjackGameView: View {
    
    @ObservedObject var blackjackGame: BlackjackGame
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Namespace private var splittingNamespace
    @State private var bet: Double = 0
    @State private var insufficientFundsAlert = false
    @State private var finished = false
    
    var body: some View {
        ZStack {
            VStack {
                availableBank
                if !blackjackGame.betPlaced {
                    Color.clear
                    Color.clear
                    Color.clear
                    betAmount
                    clearDealAndChips
                } else {
                    dealerHand
                    activePlayerHand
                        .overlay(inactivePlayerHands, alignment: .bottom)
                    doubleSplitHitStand
                        .overlay(reset, alignment: .center)
                }
            }
            .foregroundColor(.fontColor)
            .font(horizontalSizeClass == .compact ? .headline.bold() : .title3.bold())
            .padding()
            .alert(isPresented: $insufficientFundsAlert) {
                Alert(
                    title: Text("Insufficient Funds!"),
                    dismissButton: .cancel(Text("Clear Bet"), action: { clearBet() })
                )
            }
        }
    }
    
    var availableBank: some View {
        HStack {
            Text("Bank: $\(blackjackGame.bank, specifier: "%.2f")")
            Spacer()
        }
    }
    
    // MARK: Pre-Deal Views
    
    var betAmount: some View {
        HStack {
            Spacer()
            Text("Bet: $\(bet, specifier: "%.2f")")
            Spacer()
        }
        .padding()
    }
    
    var clearDealAndChips: some View {
        VStack {
            ChipsView(bet: $bet)
                .scaleEffect(horizontalSizeClass == .compact ? 0.8 : 0.65)
            HStack {
                Spacer()
                clear
                Spacer()
                deal
                Spacer()
            }
            .padding()
        }
    }
    
    var clear: some View {
        Button("Clear") {
            clearBet()
        }
    }
    
    var deal: some View {
        Button("Deal") {
           placeBetAndDeal()
        }
    }
    
    // MARK: Dealing
    
    private func placeBetAndDeal() {
        resetViewStates()
        blackjackGame.resetHands()
        if betLegal() {
            withAnimation(.easeInOut) {
                blackjackGame.placeBet(bet)
            }
            withAnimation(.easeInOut.delay(DrawingConstants.firstDealDelay)) {
                blackjackGame.dealOneToPlayer()
            }
            withAnimation(.easeInOut.delay(2 * DrawingConstants.firstDealDelay)) {
                blackjackGame.dealOneToDealer(faceUp: false)
            }
            withAnimation(.easeInOut.delay(3 * DrawingConstants.firstDealDelay)) {
                blackjackGame.dealOneToPlayer()
            }
            withAnimation(.easeInOut.delay(4 * DrawingConstants.firstDealDelay)) {
                blackjackGame.dealOneToDealer()
            }
            if blackjackGame.activePlayerHand.state == .blackjack {
                switchHandOrFinish()
            }
        } else {
            insufficientFundsAlert = true
        }
    }
    
    // MARK: Post Deal Views
    
    @ViewBuilder
    var dealerHand: some View {
        HandView(namespace: splittingNamespace, hand: blackjackGame.dealerHand, state: blackjackGame.state)
            .scaleEffect(blackjackGame.dealerHand.cards.count < 5 ? DrawingConstants.handScale : DrawingConstants.alternateHandScale)
    }
    
    @ViewBuilder
    var activePlayerHand: some View {
        HandView(namespace: splittingNamespace, hand: blackjackGame.activePlayerHand, state: blackjackGame.state)
            .scaleEffect(blackjackGame.activePlayerHand.cards.count < 5 ? DrawingConstants.handScale : DrawingConstants.alternateHandScale)
    }
    
    var inactivePlayerHands: some View {
        HStack {
            ForEach(blackjackGame.playerHands) { hand in
                if hand != blackjackGame.activePlayerHand {
                    ZStack {
                        ForEach(hand.cards.reversed()) { card in
                            Circle()
                                .matchedGeometryEffect(id: card.id, in: splittingNamespace)
                                .frame(width: DrawingConstants.circleFrame, height: DrawingConstants.circleFrame)
                                .foregroundColor(card.suit == Game.Card.Suit.diamonds || card.suit == Game.Card.Suit.hearts ? .cardRed : .cardGrey)
                        }
                    }
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
            }
        }
        .offset(y: DrawingConstants.inactivePlayerHandsOffset)
    }
    
    var doubleSplitHitStand: some View {
        VStack {
            HStack {
                Spacer()
                Button("Double") {
                    double()
                }
                Spacer()
                Button("Split") {
                    split()
                }
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                Button("Stand") {
                    stand()
                }
                Spacer()
                Button("Hit") {
                    hit()
                }
                Spacer()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var reset: some View {
        if finished {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    Button("Rebet $\(bet, specifier: "%.2f")") {
                        withAnimation(.easeInOut) {
                            placeBetAndDeal()
                        }
                    }
                    .foregroundColor(.white)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                    Button("New Game") {
                        withAnimation(.easeInOut) {
                            resetViewStates(newGame: true)
                            blackjackGame.newGame()
                        }
                    }
                    .foregroundColor(.white)
                }
               
            }
            .transition(.scale)
        }
    }
    
    // MARK: Hit, Stand, Double, Split and Results Showing
    
    private func hit() {
        withAnimation(.easeInOut) {
            blackjackGame.hit()
        }
        if blackjackGame.activePlayerHand.state != nil {
            switchHandOrFinish(delay: true)
        }
    }
    
    private func stand() {
        blackjackGame.stand()
        switchHandOrFinish()
    }
    
    private func double() {
        if betLegal() {
            withAnimation(.easeInOut) {
                blackjackGame.double()
            }
            switchHandOrFinish(delay: true)
        }
    }
    
    private func split() {
        if betLegal(), blackjackGame.activePlayerHand.splittable {
            withAnimation(.easeInOut) {
                blackjackGame.split()
            }
            withAnimation(.easeInOut.delay(DrawingConstants.playerDealDelay)) {
                blackjackGame.dealOneToPlayer()
            }
            if blackjackGame.activePlayerHand.state == .blackjack {
                switchHandOrFinish(delay: true)
            }
        }
    }
    
    private func flipAndDealDealer() -> CGFloat {
        let additionalDelay: CGFloat = blackjackGame.activePlayerHand.state == .blackjack ? (4 * DrawingConstants.firstDealDelay) : 0
        withAnimation(.easeInOut.delay(DrawingConstants.flipDelay + additionalDelay)) {
            blackjackGame.flipDealerCard()
        }
        
        var delay: CGFloat = 0
        if !blackjackGame.playerHands.allSatisfy({ $0.state == .bust }) {
            var i: CGFloat = 1
            while blackjackGame.dealerHand.score() < 17 {
                withAnimation(.easeInOut.delay(i * (DrawingConstants.dealerDealDelay + additionalDelay))) {
                    blackjackGame.dealOneToDealer()
                }
                i += 1
            }
            i += 1
            delay = (DrawingConstants.dealerDealDelay + additionalDelay) * i
        } else {
            delay = DrawingConstants.flipDelay
        }
        return delay
    }
    
    private func switchHandOrFinish(delay: Bool = false) {
        if blackjackGame.allHandsStateful {
            let delay = flipAndDealDealer()
            var j: CGFloat = 1
            for i in (0..<blackjackGame.playerHands.count).reversed() {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + (DrawingConstants.resultDelay * j)) {
                    withAnimation(.easeInOut) {
                        blackjackGame.showResult()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delay + (DrawingConstants.resultDelay * (j + 1))) {
                    withAnimation(.easeInOut) {
                        blackjackGame.resetState()
                    }
                }
                if i != 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay + (DrawingConstants.resultDelay * (j + 2))) {
                        withAnimation(.easeInOut) {
                            blackjackGame.switchToPreviousHand()
                        }
                    }
                }
                j += 3
            }
            withAnimation(.easeInOut.delay(delay + (DrawingConstants.resultDelay * (j - 1)))) {
                finished = true
            }
        } else {
            let delayMultiplier: CGFloat = delay ? 2 : 0
            DispatchQueue.main.asyncAfter(deadline: .now() + DrawingConstants.playerDealDelay * delayMultiplier) {
                withAnimation(.easeInOut) {
                    blackjackGame.switchHand()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + DrawingConstants.playerDealDelay * (delayMultiplier + 1)) {
                if blackjackGame.activePlayerHand.cards.count < 2 {
                    withAnimation(.easeInOut) {
                        blackjackGame.dealOneToPlayer()
                    }
                }
                if blackjackGame.activePlayerHand.state == .blackjack {
                    switchHandOrFinish(delay: true)
                }
            }
        }
    }
    
    // MARK: Other Functions
    
    private func clearBet() {
        bet = 0
    }
    
    private func resetViewStates(newGame: Bool = false) {
        if newGame {
            bet = 0
        }
        finished = false
        insufficientFundsAlert = false
    }
    
    private func betLegal() -> Bool {
        bet > 0 && blackjackGame.bank - bet >= 0
    }
    
    // MARK: Drawing Constants
    
    private struct DrawingConstants {
        static let handScale: CGFloat = 0.65
        static let alternateHandScale: CGFloat = 0.6
        static let circleFrame: CGFloat = 5
        static let inactivePlayerHandsOffset: CGFloat = -30
        static let cornerRadius: CGFloat = 10
        static let firstDealDelay: CGFloat = 0.4
        static let playerDealDelay: CGFloat = 0.4
        static let dealerDealDelay: CGFloat = 0.8
        static let flipDelay: CGFloat = 0.3
        static let resultDelay: CGFloat = 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let bg = BlackjackGame()
        bg.placeBet(20)
        bg.dealOneToPlayer()
        bg.dealOneToDealer()
        bg.dealOneToPlayer()
        bg.dealOneToDealer()
        return BlackjackGameView(blackjackGame: bg)
    }
}
