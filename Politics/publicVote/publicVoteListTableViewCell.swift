//
//  publicVoteListTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2019/01/31.
//  Copyright © 2019 tatsumi kentaro. All rights reserved.
//

import UIKit

class publicVoteListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var voteBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
