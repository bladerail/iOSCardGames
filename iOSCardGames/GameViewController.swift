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

    override func viewDidLoad() {
        super.viewDidLoad()

        var str = ""
        for peer in gameManager!.playerList {
            str += peer.displayName + " "
        }
        Logger.d("GameVC loaded \(str)")
        // Do any additional setup after loading the view.
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
