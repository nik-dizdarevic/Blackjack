//
//  BlackjackGame.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 04/05/2022.
//

import SwiftUI

class BlackjackGame: ObservableObject {
    
    @Published private var game = Game()
    
    var bank: Double {
        game.bank
    }
    
    var state: Game.EndState? {
        game.state
    }
    
    var betPlaced: Bool {
        game.betPlaced
    }
    
    var dealerHand: Game.Hand {
        game.dealerHand
    }
    
    var playerHands: [Game.Hand] {
        game.playerHands
    }
    
    var activePlayerHand: Game.Hand {
        game.playerHands[game.activeHandIndex]
    }
    
    var allHandsStateful: Bool {
        game.playerHands.allSatisfy({ $0.state != nil })
    }
    
    // MARK: - Intent(s)
    
    func placeBet(_ bet: Double) {
        game.placeBet(bet)
    }
    
    func dealOneToPlayer() {
        game.dealOneToPlayer()
    }
    
    func dealOneToDealer(faceUp: Bool = true) {
        game.dealOneToDealer(faceUp: faceUp)
    }
    
    func flipDealerCard() {
        game.flipDealerCard()
    }
    
    func switchHand() {
        game.switchHand()
    }
    
    func split() {
        game.split()
    }
    
    func hit() {
        game.hit()
    }
    
    func stand() {
        game.stand()
    }
    
    func double() {
        game.double()
    }
    
    func showResult() {
        game.showResult()
    }
    
    func resetState() {
        game.resetState()
    }
    
    func switchToPreviousHand() {
        game.switchToPreviousHand()
    }
    
    func resetHands() {
        game.resetHands()
    }
    
    func newGame() {
        game = Game()
    }

}
