//
//  LobbyController.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LobbyController: UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnStart: UIBarButtonItem!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtFldMsg: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Logger.d("Hello World from Lobby")
    }
    
    
    @IBAction func onInvitePressed(_ sender: Any) {
        self.present(networkManager.browserVC, animated: true, completion: nil)
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

extension UITableView {
    func scrollToLastCell(animated : Bool) {
        
        let lastSectionIndex = self.numberOfSections - 1 // last section
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1 // last row
        if (lastSectionIndex < 0 || lastRowIndex < 0) {
            return
        }
        //self.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: animated)
        
        // due to an Apple's bug, a workaround is to call scrollToRow twice, after a delay
        // https://stackoverflow.com/questions/25686490/ios-8-auto-cell-height-cant-scroll-to-last-row/25800080#25800080
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: animated)
            }
        }
    }
}
