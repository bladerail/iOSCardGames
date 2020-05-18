//
//  BridgeStrengthRule.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation

enum BridgeCmd: String {
    case BID
    case PLAYCARD
    case RECEIVECARDS
    case REQUESTSHUFFLE
    case GAMESTAGE
}

class BridgeGameLogic : GameLogic {

    var gameName = GameName.Bridge
    
    enum GameStages {
        case start
        case bid
        case play
        case end
    }
    
    let numPlayers = 4
    var deck: Deck?
    var cardsHeldByPlayers : [[Card]] = [[], [], [], []]
    var cardOrder: [Int] = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 1]
    var suitOrder: [String] = ["Club", "Diamond", "Heart", "Spade"];
    var currentGameStage = GameStages.start
    
    init() {
        deck = Deck(suitOrder, computeCardStrength)
    }
    
    func computeCardStrength(_ number: Int, _ suit: Int) -> Int {
        return (cardOrder.firstIndex(of: number)! + 1) + (suit * 13);
    }
    
    func messageReceivedHandler(_ packet: NPacket) {
        let cmd = packet.command
        switch (cmd) {
        case .bridge(.REQUESTSHUFFLE):
            break
        case .bridge(.BID):
            break
        case .bridge(.RECEIVECARDS):
            break
        case .bridge(.PLAYCARD):
            break
        case .bridge(.GAMESTAGE):
            break
        default: // Should not happen
            Logger.e("Unexpected command received \(cmd)")
            break
        }
    }
    
    func setupGame() {
        cardsHeldByPlayers = [[], [], [], []]
    }
}
