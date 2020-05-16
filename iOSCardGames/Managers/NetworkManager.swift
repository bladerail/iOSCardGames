//
//  NetworkManager.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class NetworkManager : NSObject, MCSessionDelegate, MCBrowserViewControllerDelegate, MCAdvertiserAssistantDelegate {
    
    static let shared = NetworkManager.init()
    
    let serviceType = "iOSCardGames"
    
    let localPeerID : MCPeerID
    var browserVC : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    //    var advertiser : MCNearbyServiceAdvertiser!
    var session : MCSession!
    
    var playerList : [MCPeerID] = []
    
    var serverPeerID : MCPeerID? {
        if (playerList.count == 0) {
            return nil
        } else {
            return playerList[0]
        }
        
    }
    var isServer : Bool {
        return serverPeerID == localPeerID
    }
    
    override init() {
        if let data = UserDefaults.standard.data(forKey: "peerID"), let id = NSKeyedUnarchiver.unarchiveObject(with: data) as? MCPeerID {
          self.localPeerID = id
        } else {
          let peerID = MCPeerID(displayName: UIDevice.current.name)
          let data = NSKeyedArchiver.archivedData(withRootObject: peerID)
          UserDefaults.standard.set(data, forKey: "peerID")
          self.localPeerID = peerID
        }
//        self.playerIndex = -1
        super.init()
        session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        
        
        // create the browser viewcontroller with a unique service name
        browserVC = MCBrowserViewController(serviceType:serviceType, session:self.session)
        
        
        //self.serviceBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceType)
        //self.serviceBrowser.delegate = self
        
        //        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: serviceType)
        //        advertiser.delegate = self
        //        advertiser.startAdvertisingPeer()
        assistant = MCAdvertiserAssistant(serviceType:serviceType, discoveryInfo:nil, session:self.session)
        
        
        session.delegate = self
        browserVC.delegate = self
        assistant.delegate = self
        assistant.start()    // tell the assistant to start advertising our service
    }
    
    // TODO: Allow users to provide their own names
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NotificationCenter.default.post(name: .peerConnectionState, object: nil, userInfo: ["peer": peerID, "state": state])
        switch (state) {
        case .connected:
            Logger.d(peerID.displayName + " has connected to session \(session)");
            break
        case .connecting:
            Logger.d(peerID.displayName + " is connecting to session \(session)");
            break
        case .notConnected:
            Logger.d(peerID.displayName + " has disconnected");
            break
        @unknown default:
            Logger.e("Unknown state!")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message : NPacket = try JSONDecoder().decode(NPacket.self, from: data)
            Logger.d("Received from \(peerID): \(message)")
            
            switch (message.command) {
            case .simple(.HOST):
                do {
                    let hashArray = try JSONSerialization.jsonObject(with: message.data.data(using: .utf8)!, options: []) as! [Int]
                    hostDeclaredHandler(hashArray: hashArray)
                    NotificationCenter.default.post(name: .declareHost, object: hashArray)
                } catch {
                    Logger.e("\(error)")
                }
                break
            case .simple(.CHAT):
                NotificationCenter.default.post(name: .messageReceived, object: self, userInfo: ["peer": peerID, "msg": message])
                break
            default:
                // Pass to GameManager to handle
                break
            }
        } catch {
            Logger.e("ReceiveData \(error)")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        if (browserViewController.navigationController != nil) {
            browserViewController.navigationController!.popViewController(animated: true)
        } else {
            browserViewController.dismiss(animated: true, completion: nil)
        }
        
        Logger.d("BrowserViewController Finished")
        browserViewController.browser?.stopBrowsingForPeers()
        assistant.stop()
        
        // If BrowserViewControllerDidFinish, then this is the server player
        // Update all other players' player list, by sending the hash value array to the other devices
        var hashArray: [Int] = []
        hashArray.append(localPeerID.hashValue)
        for peer in session.connectedPeers {
            hashArray.append(peer.hashValue)
        }
        Logger.d(NPacket(command: .simple(.HOST), data: hashArray.description).description)
        sendMessage(command: .simple(.HOST), body: hashArray.description)
        hostDeclaredHandler(hashArray: hashArray)
        NotificationCenter.default.post(name: .declareHost, object: hashArray)
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        Logger.d("BrowserViewController Cancelled")
        browserViewController.browser?.stopBrowsingForPeers()
        assistant.stop()
    }
    
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        Logger.d("Invitation was received, session has \(advertiserAssistant.session.connectedPeers.count) members")
    }
    
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        Logger.d("Invitation was dismissed")
    }
    
    func start() {
        assistant.start()
        browserVC.browser?.startBrowsingForPeers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func syncPlayerListWithServer(_ serverList: [MCPeerID]) {
        self.playerList = serverList
    }
    
    // Disconnect from session when app enters background
    @objc func enteredBackground() {
        self.session.disconnect()
        self.playerList = []
    }
    
    func reconnect() {
        
    }
    
    // Send update packet
    func sendMessage(command: Command, body: String) {
        sendMessage(packet: NPacket(command: command, data: body))
    }
    
    func sendMessage(packet: NPacket) {
        do {
            let payload = try JSONEncoder().encode(packet)
            try self.session.send(payload, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            Logger.e("Send Message: \(error)")
        }
    }
    
    // Send full state data
    func requestStateRefresh() {
        
    }
    
    // Update playerList and serverPeerID to match that of the host's
    // Host calls this in BrowserViewControllerDidFinish
    // Clients call this when they receive session data for the host command
    func hostDeclaredHandler(hashArray: [Int]) {
        if (serverPeerID != nil) {
            Logger.e("There is already a registered host: \(serverPeerID!.displayName)")
            return
        }
        
        var playerIndex: Int = -1
        for (idx, hash) in hashArray.enumerated() {
            for peer in session.connectedPeers {
                // For each hash value, compare against self or connectedpeers
                if (peer.hashValue == hash) {
                    self.playerList.append(peer)
                } else if (localPeerID.hashValue == hash) {
                    self.playerList.append(localPeerID)
                    // Set own player index
                    playerIndex = idx
                }
            }
        }
        Logger.d("playerList: \(playerList), playerIndex: \(playerIndex), serverPeerID: \(String(describing: serverPeerID))")
        
        // Create GameManager depending on server or client
        DispatchQueue.main.async {
            if (self.isServer) {
                (UIApplication.shared.delegate as! AppDelegate).gameManager = GameServer(peers: self.playerList, playerIndex: playerIndex)
            } else {
                (UIApplication.shared.delegate as! AppDelegate).gameManager = GameClient(peers: self.playerList, playerIndex: playerIndex)
            }
        }
    }
    
}

extension Notification.Name {
    static var peerConnectionState : Notification.Name {
        return .init(rawValue: "NetworkManager.peerConnectionState")
    }
    static var declareHost: Notification.Name {
        return .init(rawValue: "NetworkManager.declareHost")
    }
    static var messageReceived : Notification.Name {
        return .init(rawValue: "NetworkManager.receivedMessage")
    }
}

struct NPacket : Codable, CustomStringConvertible {
//    let senderHash: Int
    let command: Command
    let data : String
    
    var description: String {
        return "\(command) Data: \(data)"
    }
}
