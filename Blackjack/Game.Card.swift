//
//  Game.Card.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 11/05/2022.
//

import Foundation

extension Game {
    struct Card: Identifiable, Equatable {
        let id: Int
        let suit: Suit
        let rank: Rank
        var isFaceUp = false
        
        enum Suit: String, CaseIterable {
            case clubs = "suit.club.fill"
            case diamonds = "suit.diamond.fill"
            case hearts = "suit.heart.fill"
            case spades = "suit.spade.fill"
        }
        
        enum Rank: String, CaseIterable {
            case ace = "A"
            case two = "2"
            case three = "3"
            case four = "4"
            case five = "5"
            case six = "6"
            case seven = "7"
            case eight = "8"
            case nine = "9"
            case ten = "10"
            case jack = "J"
            case queen = "Q"
            case king = "K"
        }
    }
}
