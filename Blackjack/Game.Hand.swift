//
//  Game.Hand.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 16/05/2022.
//

import Foundation

extension Game {
    
    struct Hand: Identifiable, Equatable {
        var id: Int
        var cards: [Card] = []
        var bet: Double?
        var state: FinishState?
        
        var splittable: Bool {
            cards.count == 2 && cards[0].rank == cards[1].rank
        }
        
        var doublable: Bool {
            cards.count == 2
        }

        func score() -> Int {
            let cardValues: [Card.Rank:Int] = [.ace: 11, .two: 2, .three: 3, .four: 4, .five: 5, .six: 6, .seven: 7, .eight: 8, .nine: 9, .ten: 10, .jack: 10, .queen: 10, .king: 10]
            
            var score = 0
            var aceSeen = false
            var hard = false
            for card in cards.filter({ $0.isFaceUp }) {
                if card.rank == .ace {
                    if !aceSeen {
                        score += cardValues[card.rank] ?? 0
                        aceSeen = true
                    } else {
                        score += 1
                    }
                } else {
                    score += cardValues[card.rank] ?? 0
                }
                if score > 21, aceSeen, !hard {
                    score -= 10
                    hard = true
                }
            }
            
            return score
        }
        
        func blackjack() -> Bool {
            cards.count == 2 && score() == 21
        }
        
        enum FinishState {
            case stand
            case bust
            case blackjack
        }
        
    }
}
