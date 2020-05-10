//
//  ViewController.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var createLobbyButton: UIButton!
    @IBOutlet weak var joinLobbyButton: UIButton!
    @IBOutlet weak var tblLogs: UITableView!
    
    let notificationCenter = NotificationCenter.default
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Logger.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLogs.dequeueReusableCell(withIdentifier: "tblLogsCell", for: indexPath) as! LogTableViewCell
        print("CellFrame \(cell.contentView.frame.size)")
        let text = Logger.logs[indexPath.row]
        
        cell.logLabel.text = text
        print("NewCellFrame \(cell.contentView.frame.size)")
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblLogs.dataSource = self
        tblLogs.delegate = self
        tblLogs.rowHeight = UITableView.automaticDimension
        tblLogs.estimatedRowHeight = 40
        
        notificationCenter.addObserver(self,
                                       selector: #selector(logsRefreshed),
                                       name: .refreshLogs,
                                       object: nil)
        Logger.d("Hello World")
    }
    
    @objc private func logsRefreshed(_ notification: Notification) {
        print("Old Frame \(tblLogs.contentSize)")
        tblLogs.reloadData()
    }

    @IBAction func onCreateLobbyPressed(_ sender: Any) {
        Logger.d("Button Pressed")
        let vc :UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "LobbyController"))!
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
    self.navigationController?.pushViewController(vc, animated: true)
    }
}

