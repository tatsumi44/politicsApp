//
//  PastChartsTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/13.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class PastChartsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
