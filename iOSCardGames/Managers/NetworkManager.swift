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
    
    let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    var browserVC : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    //    var advertiser : MCNearbyServiceAdvertiser!
    var session : MCSession!
    
    override private init() {
        
        session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        
        
        // create the browser viewcontroller with a unique service name
        browserVC = MCBrowserViewController(serviceType:serviceType, session:self.session)
        
        
        //self.serviceBrowser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceType)
        //self.serviceBrowser.delegate = self
        
        //        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: serviceType)
        //        advertiser.delegate = self
        //        advertiser.startAdvertisingPeer()
        assistant = MCAdvertiserAssistant(serviceType:serviceType, discoveryInfo:nil, session:self.session)
        
        super.init()
        session.delegate = self
        browserVC.delegate = self
        assistant.delegate = self
        assistant.start()    // tell the assistant to start advertising our service
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch (state) {
        case .connected:
            Logger.d(peerID.displayName + " has connected");
            break
        case .connecting:
            Logger.d(peerID.displayName + " is connecting");
            break
        case .notConnected:
            Logger.d(peerID.displayName + " has disconnected");
            break
        @unknown default:
            Logger.e("Unknown state!")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let rawData = String(data: data, encoding: .utf8) {
            Logger.d("Received from \(peerID): \(rawData)")
        } else {
            Logger.e("RawData error")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        Logger.d("BrowserViewController Finished")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        Logger.d("BrowserViewController Cancelled")
    }
    
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        Logger.d("Invitation was received, session has \(advertiserAssistant.session.connectedPeers.count) members")
    }
    
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        Logger.d("Invation was dismissed")
    }
    
}
