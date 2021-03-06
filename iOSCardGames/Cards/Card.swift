//
//  Card.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

class Card : Codable, CustomStringConvertible {
    let number : Int // Number on the card itself
    let suit: Int
    let suitStr: String
    var isPlayed: Bool
    let strength: Int // The computed strength value of this card
    
    public init(_ number: Int, _ suit: Int, _ suitOrder: [String], _ computeCardStrength: (Int, Int) -> Int) {
        self.number = number
        self.suit = suit
        self.suitStr = suitOrder[suit]
        self.isPlayed = false
        self.strength = computeCardStrength(number, suit)
    }
    
    // Returns true if card1 is weaker than card2
    public static func compare(_ card1: Card?, _ card2: Card?) -> Bool {
        let card1Strength = card1?.strength ?? -999
        let card2Strength = card2?.strength ?? -999
        return card1Strength < card2Strength
    }
    
    var description: String {
        return "\(number) \(suitStr)"
    }
}
