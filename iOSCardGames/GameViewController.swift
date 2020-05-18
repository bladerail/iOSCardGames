//
//  GameViewController.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 17/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var gameManager = AppDelegate.realDelegate.gameManager
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnDeal: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.d("GameController Appear")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var str = ""
        for peer in gameManager!.playerList {
            str += peer.displayName + " "
        }
        Logger.d("GameVC loaded. Game is \(String(describing: gameManager?.currentGameLogic))")
        // Do any additional setup after loading the view.
        
        if (gameManager!.isServer) {
            btnStart.isEnabled = true
            btnDeal.isEnabled = true
        } else {
            btnStart.isEnabled = false
            btnDeal.isEnabled = false
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
