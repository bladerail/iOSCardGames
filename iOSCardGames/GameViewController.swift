//
//  GameViewController.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 17/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var gameManager = GameManager.shared
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnDeal: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.d("GameController Appear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var str = ""
        for peer in gameManager.playerList {
            str += peer.displayName + " "
        }
        Logger.d("GameVC loaded. Game is \(String(describing: gameManager.currentGameLogic))")
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            if (self.gameManager.isServer) {
                self.btnStart.isEnabled = true
                self.btnDeal.isEnabled = true
            } else {
                self.btnStart.isEnabled = false
                self.btnDeal.isEnabled = false
            }
        }
        
    }
    
    @IBAction func onStartPressed(_ sender: Any) {
        gameManager.sendPacket(packet: NPacket(command: .bridge(.GAMESTAGE), string: BridgeGameLogic.GameStages.start.rawValue))
    }
    
    @IBAction func onDealPressed(_ sender: Any) {
        if (gameManager.isServer) {
            gameManager.currentGameLogic?.setupGame()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
