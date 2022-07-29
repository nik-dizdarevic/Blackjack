//
//  Game.Bet.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 11/05/2022.
//

import Foundation

extension Game {
    enum Bet: Int, CaseIterable, Identifiable {
        case five = 5
        case twentyFive = 25
        case fifty = 50
        case oneHundred = 100

        var id: Self { self }
    }
}
