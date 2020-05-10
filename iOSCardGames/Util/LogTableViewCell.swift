//
//  LogTableViewCell.swift
//  iOSCardGames
//
//  Created by Joshua Ng on 11/5/20.
//  Copyright © 2020 Joshua Ng. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
