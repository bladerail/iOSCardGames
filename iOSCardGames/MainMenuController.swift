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
        
        let text = Logger.logs[indexPath.row]
        
        cell.logLabel.text = text

        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        registerObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewWilDisappear")
        
    }
    
    func registerObservers() {
        notificationCenter.addObserver(self, selector: #selector(logsRefreshedHandler), name: .refreshLogs, object: nil)
    }
    
    func unregisterObservers() {
        notificationCenter.removeObserver(self, name: .refreshLogs, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblLogs.dataSource = self
        tblLogs.delegate = self
        tblLogs.rowHeight = UITableView.automaticDimension
        tblLogs.estimatedRowHeight = 40
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mainVC = self
        
        
        Logger.d("Hello World")
    }
    
    @objc private func logsRefreshedHandler(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tblLogs.reloadData()
        }
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

