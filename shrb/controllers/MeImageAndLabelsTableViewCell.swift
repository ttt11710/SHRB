//
//  MeImageAndLabelsTableViewCell.swift
//  shrb
//
//  Created by PayBay on 15/6/24.
//  Copyright (c) 2015年 PayBay. All rights reserved.
//

import UIKit

class MeImageAndLabelsTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
