//
//  FiveDaysAgoResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class FiveDaysAgoResultViewController: TodayResultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        day = nowDate(num: 5)
//        questionArray = mainQuestionArray[day]!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListTableViewCell") as! TopListTableViewCell
        if let title = questionArray[indexPath.row].title{
            cell.mainLabel.text = "\(shortNowDate(num: 5))の投票データ"
            cell.contentLabel.text = title
            cell.subLabel.textColor = UIColor.hex(string: "#1167C0", alpha: 1)
        }
        return cell
    }

}
