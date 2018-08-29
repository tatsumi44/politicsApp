//
//  NewsTodayTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WCLShineButton
class NewsTodayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeLabel: WCLShineButton!
    @IBOutlet weak var disLikeLabel: WCLShineButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var disLikeCount: UILabel!
    @IBOutlet weak var titleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
