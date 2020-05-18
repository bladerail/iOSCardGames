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
    
    static let shared = GameManager.init()
    
    var playerList: [MCPeerID] = []
    var playerIndex: Int = -1
    var isServer : Bool { playerIndex == 0}
    var currentGameLogic: GameLogic?
    var gameViewController: GameViewController?
    
    init() {
        
    }
    
    func set(players: [MCPeerID], playerIndex: Int) {
        self.playerList = players
        self.playerIndex = playerIndex
        self.currentGameLogic = nil
        DispatchQueue.main.async {
            self.gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        }
        
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
        if (isServer) {
            currentGameLogic?.setupGame()
            NetworkManager.shared.sendMessage(packet: NPacket(command: .simple(.LAUNCH), string: "Game"))
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
