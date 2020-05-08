//
//  BridgeStrengthRule.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

class BridgeGameRule : GameRule {
    var cardOrder: [Int] = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1]
    var suitOrder: [String] = ["Club", "Diamond", "Heart", "Spade"];
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int {
        return (cardOrder.firstIndex(of: number)! + 1) + (suit * 13);
    }
}
