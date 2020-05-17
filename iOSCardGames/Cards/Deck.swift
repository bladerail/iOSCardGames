//
//  Deck.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

class Deck {
    private var rule : GameLogic
    private var cardList = [Card]()
    
    init(_ rule: GameLogic) {
        self.rule = rule
        for suit in 0...3 {
            for value in 1...13 {
                cardList.append(Card(value, suit, rule))
            }
        }
    }
    // Use the Fisher-Yates Shuffle algorithm
    public func shuffle() {
        for i in (0...(cardList.count - 1)).reversed() {
            let j = Int(arc4random_uniform(52))
            //print("i = \(i) j = \(j)");
            cardList.swapAt(i,j)
        }
        //print("After shuffling:")
        //printDeck()
    }
}
