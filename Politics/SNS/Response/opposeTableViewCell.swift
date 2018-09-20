//
//  opposeTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/11.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class opposeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var opposeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var docIdLabel: UILabel!
    
    @IBOutlet weak var alertFlagBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
