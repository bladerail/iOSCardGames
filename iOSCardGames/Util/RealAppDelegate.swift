//
//  RealAppDelegate.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 17/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
    static var realDelegate: AppDelegate {
        if Thread.isMainThread{
            return UIApplication.shared.delegate as! AppDelegate;
        }
        
        var appDelegate: AppDelegate?
        DispatchQueue.main.sync {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
        }
        return appDelegate!;
    }
}
