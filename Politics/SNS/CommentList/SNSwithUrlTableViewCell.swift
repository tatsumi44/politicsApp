//
//  SNSwithUrlTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/03.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WCLShineButton
class SNSwithUrlTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlBtn: UIButton!
    @IBOutlet weak var tag1Label: UILabel!
    @IBOutlet weak var tag2Label: UILabel!
    @IBOutlet weak var tag3Label: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeBtn: WCLShineButton!
    @IBOutlet weak var disLikeBtn: WCLShineButton!
    @IBOutlet weak var commnetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var disLikeCount: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
