//
//  ChipsView.swift
//  Blackjack
//
//  Created by Nik Dizdarevic on 08/05/2022.
//

import SwiftUI

struct ChipsView: View {
    @Binding var bet: Double
    
    var body: some View {
        HStack {
            ForEach(Game.Bet.allCases) { bet in
                ChipView(bet: bet)
                    .padding()
                    .onTapGesture {
                        self.bet += Double(bet.rawValue)
                    }
            }
        }
    }
}

struct BetView_Previews: PreviewProvider {
    static var previews: some View {
        ChipsView(bet: .constant(5))
    }
}
