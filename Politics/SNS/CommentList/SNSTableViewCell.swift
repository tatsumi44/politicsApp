//
//  SNSTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/17.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WCLShineButton
class SNSTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likebtn: WCLShineButton!
    @IBOutlet weak var dislikebtn: WCLShineButton!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var commenNum: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var disLikeNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }
    
    

    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
