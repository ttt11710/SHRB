//
//  RightDetailTableViewCell.swift
//  shrb
//
//  Created by PayBay on 15/6/23.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
