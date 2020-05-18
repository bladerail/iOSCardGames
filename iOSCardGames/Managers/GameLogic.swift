//
//  StrengthRule.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

protocol GameLogic {
    var gameManager: GameManager { get }
    var gameName: GameName { get set }
    var cardOrder: [Int] { get set }
    var suitOrder: [String] { get set }
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int
    
    // Message passed on by GameManager
    func messageReceivedHandler(_ packet : NPacket)
    
    func setupGame()

}


enum GameName : String {
    case Solitaire
    case Blackjack
    case Poker
    case Bridge
}
