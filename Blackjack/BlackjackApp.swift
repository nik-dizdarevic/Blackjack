//
//  BlackjackApp.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 03/05/2022.
//

import SwiftUI

@main
struct BlackjackApp: App {
    @StateObject private var game = BlackjackGame()
    
    var body: some Scene {
        WindowGroup {
            BlackjackGameView(blackjackGame: game)
        }
    }
}
