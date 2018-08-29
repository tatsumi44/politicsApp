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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! PastChartsTableViewCell
        if tableView.tag == 1{
            cell.choiceLabel.text = resultArray[indexPath.row].title
            cell.numberLabel.text = "投票数\(resultArray[indexPath.row].num1!)票"
            cell.percentLabel.text = "\(resultArray[indexPath.row].percent)%"
            
        }
        return cell
    }

}