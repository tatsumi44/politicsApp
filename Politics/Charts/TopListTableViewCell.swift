//
//  TopListTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2019/01/25.
//  Copyright © 2019 tatsumi kentaro. All rights reserved.
//

import UIKit

class TopListTableViewCell: UITableViewCell {
    

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
