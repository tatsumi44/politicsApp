//
//  commentTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/18.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WCLShineButton
class commentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var btn1: WCLShineButton!
    @IBOutlet weak var btn2: WCLShineButton!
    @IBOutlet weak var likecount: UILabel!
    @IBOutlet weak var dislikecount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
