//
//  Game.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 04/05/2022.
//

import Foundation

struct Game {
    
    private var deck: [Card]
    private(set) var bank: Double = 2500
    private(set) var dealerHand = Hand(id: 0)
    private(set) var playerHands = [Hand(id: 1)]
    private(set) var activeHandIndex = 0
    private(set) var state: EndState?
    private(set) var betPlaced = false
    
    init() {
        deck = []
        var i = 0
        for _ in 0...7 {
            for suit in Card.Suit.allCases {
                for rank in Card.Rank.allCases {
                    deck.append(Card(id: i, suit: suit, rank: rank))
                    i += 1
                }
            }
        }
        deck.shuffle()
    }
    
    private mutating func dealOne() -> Card {
        if deck.count < 1 {
            var i = 0
            for suit in Card.Suit.allCases {
                for rank in Card.Rank.allCases {
                    deck.append(Card(id: i, suit: suit, rank: rank))
                    i += 1
                }
            }
            deck.shuffle()
        }
        return deck.remove(at: deck.count - 1)
    }
    
    mutating func dealOneToPlayer() {
        var card = dealOne()
        card.isFaceUp = true
        playerHands[activeHandIndex].cards.append(card)
        
        if playerHands[activeHandIndex].blackjack() {
            playerHands[activeHandIndex].state = .blackjack
        }
    }
    
    mutating func dealOneToDealer(faceUp: Bool) {
        var card = dealOne()
        card.isFaceUp = faceUp
        dealerHand.cards.append(card)
    }
    
    mutating func placeBet(_ bet: Double) {
        bank -= bet
        playerHands[activeHandIndex].bet = bet
        betPlaced = true
    }
    
    mutating func flipDealerCard() {
        for i in dealerHand.cards.indices {
            dealerHand.cards[i].isFaceUp = true
        }
    }
    
    mutating func switchHand() {
        if let i = playerHands.firstIndex(where: { $0.state == nil }) {
            activeHandIndex = i
        }
    }
    
    mutating func split() {
        if let card = playerHands[activeHandIndex].cards.popLast(), let bet = playerHands[activeHandIndex].bet, let id = playerHands.map({ $0.id }).max() {
            let newHand = Hand(id: id + 1, cards: [card], bet: bet)
            bank -= bet
            playerHands.append(newHand)
        }
    }
    
    mutating func hit() {
        dealOneToPlayer()
        switch playerHands[activeHandIndex].score() {
        case 21:
            playerHands[activeHandIndex].state = .stand
        case 0..<21:
            break
        case 22...:
            playerHands[activeHandIndex].state = .bust
        default:
            break
        }
    }
    
    mutating func stand() {
        playerHands[activeHandIndex].state = .stand
    }
    
    private mutating func doubleBet() {
        let bet = playerHands[activeHandIndex].bet ?? 0
        bank -= bet
        playerHands[activeHandIndex].bet = bet * 2
    }
    
    mutating func double() {
        if playerHands[activeHandIndex].doublable {
            doubleBet()
            dealOneToPlayer()
            
            switch playerHands[activeHandIndex].score() {
            case 0...21:
                playerHands[activeHandIndex].state = .stand
            case 22...:
                playerHands[activeHandIndex].state = .bust
            default:
                break
            }
        }
    }
    
    mutating func showResult() {
        let bet = playerHands[activeHandIndex].bet ?? 0
        switch playerHands[activeHandIndex].state {
        case .blackjack:
            if dealerHand.blackjack() {
                state = .push
                bank += bet
            } else {
                state = .playerWins
                bank += (bet + (bet * 1.5))
            }
        case .bust:
            state = .dealerWins
        case .stand:
            let playerScore = playerHands[activeHandIndex].score()
            if dealerHand.score() > 21 {
                state = .playerWins
                bank += (bet * 2)
            } else if dealerHand.score() == playerScore {
                state = .push
                bank += bet
            } else if dealerHand.score() > playerScore {
                state = .dealerWins
            } else if dealerHand.score() < playerScore {
                state = .playerWins
                bank += (bet * 2)
            }
        default:
            break
        }
    }
    
    mutating func resetState() {
        state = nil
    }
    
    mutating func switchToPreviousHand() {
        activeHandIndex -= 1
    }
    
    mutating func resetHands() {
        dealerHand = Hand(id: 0)
        playerHands = [Hand(id: 1)]
        activeHandIndex = 0
    }
    
    enum EndState {
        case push
        case dealerWins
        case playerWins
    }
}
