//
//  PastResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/13.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class PastResultViewController: ChartsResultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(self.fooButtonTapped))
        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sort descending"), style: .plain, target: self, action: #selector(self.fooButtonTapped))
        // add the button to navigationBar
        self.navigationItem.setRightBarButtonItems([rightSearchBarButtonItem], animated: true)

        // Do any additional setup after loading the view.
    }
    @objc func fooButtonTapped(){
        print("タップ")
        performSegue(withIdentifier: "b", sender: nil)
    }
    func searchButtonTapped(){
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let month = day.components(separatedBy: "_")[1]
        let day1 = day.components(separatedBy: "_")[2]
        self.title = "\(month)月\(day1)日"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartsResultListTableViewCell", for: indexPath) as! ChartsResultListTableViewCell
        let color = bgolors[indexPath.row] as? UIColor
        cell.bgView.layer.borderColor = color?.cgColor
        cell.bgView.layer.borderWidth = 4
        cell.bgView.layer.cornerRadius = 4
        cell.bgView.layer.masksToBounds = true
        cell.titleLabel.text = resultArray[indexPath.row].title
        cell.countLabel.text = "投票数 \(resultArray[indexPath.row].num1!)票"
        cell.percentLabel.text = "\((round(resultArray[indexPath.row].percent * 10)/10))%"
        return cell
       
    }

}
