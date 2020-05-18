//
//  GameManager.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 12/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GameManager {
    
    var playerList: [MCPeerID]
    var playerIndex: Int
    var isServer : Bool { playerIndex == 0}
    var currentGameLogic: GameLogic?
    
    init(players: [MCPeerID], playerIndex: Int) {
        self.playerList = players
        self.playerIndex = playerIndex
        self.currentGameLogic = nil
    }
    
    func packetReceivedHandler(packet: NPacket) {
        
    }
    
    func sendPacket(packet: NPacket) {
        
    }
    
    func setGameLogic(gameName: GameName) {
        Logger.d("\(gameName)")
        switch (gameName) {
        case .Bridge:
            currentGameLogic = BridgeGameLogic()
            break
        case .Blackjack, .Poker, .Solitaire:
            currentGameLogic = nil
            break
        }
    }
    
}
