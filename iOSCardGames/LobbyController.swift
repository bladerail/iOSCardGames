//
//  LobbyController.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 8/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class LobbyController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var btnStart: UIBarButtonItem!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtFldMsg: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var viewKB: UIView!
    
    @IBOutlet weak var viewKBBottomConstraint: NSLayoutConstraint!
    
    let networkManager = NetworkManager.shared
    let gameManager = AppDelegate.realDelegate.gameManager
    
    var chatLog:[ChatBubble] = []
    var kbMoved: Bool = false   // see the explanation for viewWillAppear
    var originalKBConstraints : [NSLayoutConstraint] = [] // to store the original constraints of viewKB
    var originalTblConstraints : [NSLayoutConstraint] = []   // for tblChat
    
    var shouldRegisterObservers = true
    
    override func viewWillAppear(_ animated: Bool) {
        if (shouldRegisterObservers) {
            
            // When the user taps on the chat textfield, we need to shift the tableview and textfield up to make them visible.
            // So, we ask to be notified when the keyboard is about to be shown and about to be removed from screen. We call the selector
            // functions to adjust the frames of the tableview and the uiview containing the textfield and Send button
            // But, somehow multiple notifications may be sent, so need a workaround with a bool variable kbMoved, defined above
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(updatePeerConnected), name: .peerConnectionState, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(updateHost), name: .declareHost, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(messageReceivedHandler), name: .messageReceived, object: nil)
            shouldRegisterObservers = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Logger.d(String(describing: self.navigationController?.topViewController))
        if ((self.navigationController!.topViewController as? MCBrowserViewController) == nil) {
            // Not going to browserVC
            unregisterObservers()
            shouldRegisterObservers = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Logger.d("Hello World from Lobby")
        self.txtFldMsg.delegate = self
        
        self.tblChat.delegate = self    // need to implement UITableViewDelegate
        self.tblChat.dataSource = self  // need to implement UITableViewDataSource
        self.tblChat.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        self.tblChat.allowsSelection = false;
        self.tblChat.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    
    @IBAction func onInvitePressed(_ sender: Any) {
        networkManager.start()
        self.navigationController?.pushViewController(networkManager.browserVC, animated: true)
    }
    
    // Chat Send button clicked, keep the keyboard in view so no need to resignFirstResponder
    fileprivate func sendChatMessage() {
        let msgSent = networkManager.sendMessage(command: .simple(.HOST), body: txtFldMsg.text!)
        
        let chatObj = ChatBubble.init(withMsg: txtFldMsg.text!, by:"Self", on:NSDate())
        chatLog.append( chatObj )       // append to the array list
        
        if (!msgSent) {
            let chatObj2 = ChatBubble.init(withMsg: "There is no session", by:"Admin", on:NSDate())
            chatLog.append(chatObj2)
        }
        self.tblChat.reloadData()  // to refresh the UITableView
        txtFldMsg.text = ""     // clear the textfield so that it's easy to type the next message
        self.tblChat.scrollToLastCell(animated : true)
    }
    
    @IBAction func onSendPressed(_ sender: UIButton) {
        if txtFldMsg.text?.count == 0 {
            return
        }

        sendChatMessage()  // Scroll to the last row of the tableview
    }
    
    // MARK: UITextFieldDelegate
    // this function is called when the Return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtFldMsg.text?.count == 0 { // if there is no chat text
            textField.resignFirstResponder() // to hide the keyboard
            return true
        }
        
        sendChatMessage()
        
        textField.resignFirstResponder() // to hide the keyboard
        return true
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let chatObj = chatLog[indexPath.row]
        return chatObj.getRowHeight()
    }
    
    // MARK: UITableViewDataSource
    // The next 3 functions are UITableViewDataSource protocols to display the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatObj = chatLog[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath)
        
        for subview in (cell.contentView.subviews) {
            subview.removeFromSuperview()
        }
        let bubbleView = getBubbleView(withChatObj: chatObj)  // construct the view to add to each tableview row or cell
        cell.contentView.addSubview( bubbleView )
        
        chatObj.setRowHeight(bubbleView.frame.size.height+5) // update the cell's height in the chat object, with a gap of 5 pixels
        return cell
    }
    
    func getBubbleView(withChatObj chatObj:ChatBubble) -> UIView {
            
            var img : UIImage
            let myInsets: UIEdgeInsets
            var lblX : CGFloat = 0 // x-coord for lblMsg
            var lblY : CGFloat = 15  // y-coord for lblMsg
            var viewX : CGFloat // x-coord for final view
            
            let screenSize: CGRect = UIScreen.main.bounds
            let font = UIFont (name: "ArialMT", size: 16)
            var displayWidth:CGFloat = screenSize.width / 1.5  // set the largest width for each bubble
            
            let lblMsg = UILabel(frame: CGRect(x:0, y:10, width:10, height:90)) // initial values will be changed later
            
            lblMsg.font = font
            //lblMsg.font = UIFont.systemFont(ofSize: 16)
            //lblMsg.backgroundColor = UIColor.red  // turn on during debugging to see actual area occupied
            lblMsg.numberOfLines = 0 // Making it multiline
            lblMsg.text = chatObj.getMsg()
            
            let lblSenderName = UILabel(frame: CGRect(x:0, y:30, width:10, height:90))
            lblSenderName.font = font
            lblSenderName.textColor = UIColor.blue
            //lblSenderName.backgroundColor = UIColor.yellow  // turn on during debugging to see actual area occupied
            lblSenderName.numberOfLines = 1 // 1-line name
            lblSenderName.text = " - "  // will be changed below
            
            let msg = chatObj.getMsg()
            var txtWidth = msg.widthOfString(usingFont: font!)
            if txtWidth > displayWidth {
                txtWidth = displayWidth - 20
            }
            
            if chatObj.getSender() == "Self" {  // my message
                img = UIImage(named: "myBubble.png")!
                myInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 18, right: 20)
                lblX = 10
                lblY = 10
                viewX = screenSize.size.width - displayWidth //200
            }
            else {  // others
                img = UIImage(named: "othersBubble2.png")!
                myInsets = UIEdgeInsets.init(top: 8, left: 20, bottom: 18, right: 8)
                lblX = 10
                lblY = 10
                viewX = 5
                lblSenderName.text = chatObj.getSender()  // need to modify this accordingly
            }
            img = img.resizableImage(withCapInsets: myInsets, resizingMode: .stretch)
            if txtWidth < img.size.width {
                txtWidth = img.size.width
            }
            var displayHeight:CGFloat = img.size.height
            let sizeRequired = lblMsg.font.sizeOfString(string: lblMsg.text!, constrainedToWidth: Double(txtWidth))
            var txtHeight:CGFloat = 0
            if sizeRequired.height < img.size.height-20 {  // if the message is just a 1-liner
                txtHeight = sizeRequired.height
                displayHeight = img.size.height + 0
            } else {
                txtHeight = sizeRequired.height
                displayHeight = sizeRequired.height+20
            }
            
            /*if sizeRequired.width < img.size.width-20 {
                displayWidth = img.size.width
            } else {
                displayWidth = sizeRequired.width + 30
            }*/
            displayWidth = sizeRequired.width + 20  // with buffer of 10 on each side
            
            // setup the views, logically arrange additional views for new features
    //        let bubbleImage: UIImageView = UIImageView(image: img)
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width:10, height:10))
            let blue = UIColor(red:0, green:160.0/255, blue:1, alpha:1)
            let grey = UIColor(red:229.0/255, green:229.0/255, blue:229.0/255, alpha:1)
            
            if chatObj.getSender() == "Self" {  // shift the view closer to the right edge, only for my message
                viewX = screenSize.size.width - displayWidth-5
                lblMsg.frame = CGRect(x:lblX, y:lblY, width:txtWidth, height:txtHeight)
                lblMsg.textColor = UIColor.white
                view.backgroundColor = blue
                view.addSubview(lblMsg)
                //print("\(lblX) \(lblY) \(txtWidth) \(txtHeight)")
            }
            else {  // other's message
                let h = lblSenderName.text?.heightOfString(usingFont: font!)
                let w = lblSenderName.text?.widthOfString(usingFont: font!)
                if (w! > txtWidth) {
                    txtWidth = w!
                    //displayWidth = w! + 30
                }
                displayWidth = txtWidth + 20
                displayHeight += h!  // increase the display height to account for name label
                lblSenderName.frame = CGRect(x:lblX, y:lblY, width:txtWidth, height:h!)
                //bubbleImage.addSubview(lblSenderName)  // add name label to UIImageView
                 
                lblY += h!
                lblMsg.frame = CGRect(x:lblX, y:lblY, width:txtWidth, height:txtHeight)
                lblMsg.textColor = UIColor.black
                view.backgroundColor = grey
                view.addSubview(lblSenderName)
                view.addSubview(lblMsg)
            }
            //bubbleImage.frame = CGRect(x:0, y: 0, width:displayWidth, height:displayHeight)
            //bubbleImage.addSubview(lblMsg)  // add lblMsg to UIImageView
            
            //let view = UIView(frame: CGRect(x: viewX, y: 0, width:displayWidth, height:displayHeight))
            view.frame = CGRect(x: viewX, y: 0, width:displayWidth, height:displayHeight)
            view.layer.cornerRadius = 8
            //view.addSubview(bubbleImage)   // add UIImageView to view
            
            return view
        }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if (!kbMoved) {
            let info = sender.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.viewKBBottomConstraint.constant -= keyboardFrame.size.height
                
            })
            self.tblChat.scrollToLastCell(animated : true)

            kbMoved = true
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        if (kbMoved) {
//            let info = sender.userInfo!
//            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.viewKBBottomConstraint.constant = 0.0
            })
            kbMoved = false
        }
    }
    
    @objc private func updatePeerConnected(_ notification: Notification) {
        let obj = notification.userInfo
        let peerID = obj!["peer"] as! MCPeerID
        let state = obj!["state"] as! MCSessionState
        switch state {
        case .connected:
            let chatObj = ChatBubble.init(withMsg: peerID.displayName + " has connected", by: networkManager.localPeerID.displayName, on: NSDate())
            self.chatLog.append(chatObj)
            break
        case .connecting:
            let chatObj = ChatBubble.init(withMsg: peerID.displayName + " is connecting", by: networkManager.localPeerID.displayName, on: NSDate())
            self.chatLog.append(chatObj)
            break
        case .notConnected:
            let chatObj = ChatBubble.init(withMsg: peerID.displayName + " has disconnected", by: networkManager.localPeerID.displayName, on: NSDate())
            self.chatLog.append(chatObj)
            break
        @unknown default:
            Logger.e("Error")
        }
        
        DispatchQueue.main.async {
            self.tblChat.reloadData()
            self.tblChat.scrollToLastCell(animated : true)
        }
    }
    
    @objc private func messageReceivedHandler(_ notification: Notification) {
        let peerID = notification.userInfo!["peer"] as! MCPeerID
        let message = notification.userInfo!["msg"] as! NPacket
        Logger.d("UIHandling \(message.command) \(message.data)")
        switch (message.command) {
        case .simple:
            let chatObj = ChatBubble.init(withMsg: message.data, by: peerID.displayName, on: NSDate())
            self.chatLog.append(chatObj)
            DispatchQueue.main.async {
                self.tblChat.reloadData()
                self.tblChat.scrollToLastCell(animated : true)
            }
            break
        default:
            break
        }
        
    }
    
    @objc func updateHost(_ notification: Notification) {
        let hashArray = notification.object as! [Int]
        let chatObj : ChatBubble
        if (networkManager.isServer) {
            chatObj = ChatBubble.init(withMsg: hashArray.description, by: "Self", on: NSDate())
        } else {
            chatObj  = ChatBubble.init(withMsg: hashArray.description, by: networkManager.serverPeerID!.displayName, on: NSDate())
        }
        
        self.chatLog.append(chatObj)
        DispatchQueue.main.async {
            self.tblChat.reloadData()
            self.tblChat.scrollToLastCell(animated : true)
        }
        
    }
    
    func unregisterObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil )
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .peerConnectionState, object: nil)
        NotificationCenter.default.removeObserver(self, name: .declareHost, object: nil)
        NotificationCenter.default.removeObserver(self, name: .messageReceived, object: nil)
    }
}

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: self],
                                                     context: nil).size
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
