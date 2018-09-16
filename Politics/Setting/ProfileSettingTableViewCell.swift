//
//  ProfileSettingTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/15.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ProfileSettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
