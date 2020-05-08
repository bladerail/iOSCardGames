//
//  Card.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

class Card {
    var number : Int // Number on the card itself
    var suit: Int
    var isPlayed: Bool
    var strength: Int // The computed strength value of this card
    
    public init(_ number: Int, _ suit: Int, _ rule: GameRule) {
        self.number = number
        self.suit = suit
        self.isPlayed = false
        self.strength = rule.computeCardStrength(number, suit)
    }
    
    public func description() -> String {
        return "\(number) \(suit))"
    }
}
