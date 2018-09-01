//
//  ChartsResultListTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/01.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class ChartsResultListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var numView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
