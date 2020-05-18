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
    var gameViewController: GameViewController?
    
    init(players: [MCPeerID], playerIndex: Int) {
        self.playerList = players
        self.playerIndex = playerIndex
        self.currentGameLogic = nil
    }
    
    func packetReceivedHandler(packet: NPacket) {
        if (self.playerIndex == packet.playerIndex || packet.playerIndex == nil) {
            // This is the intended recipient, process the packet
            currentGameLogic!.messageReceivedHandler(packet)
        }
    }
    
    func sendPacket(packet: NPacket) {
        NetworkManager.shared.sendMessage(packet: packet)
    }
    
    func startGame() {
        DispatchQueue.main.async {
            self.gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        }
        if (isServer) {
            currentGameLogic?.setupGame()
        }
    }
    
    func setGameLogic(gameName: GameName) {
        Logger.d("\(gameName)")
        switch (gameName) {
        case .Bridge:
            currentGameLogic = BridgeGameLogic(gm: self, playerIndex: self.playerIndex)
            break
        case .Blackjack, .Poker, .Solitaire:
            currentGameLogic = nil
            break
        }
    }
    
}
