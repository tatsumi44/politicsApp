//
//  TodayResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import SwiftDate
import Firebase
class TodayResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var mainTable: UITableView!
    var mainQuestionArray = [String:[Qusetions]]()
    var questionArray = [Qusetions]()
    var num:Int!
    var day:String!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        questionArray = appDelegate.questionArray
        self.mainTable.register(UINib(nibName: "TopListTableViewCell", bundle: nil), forCellReuseIdentifier: "TopListTableViewCell")
//        print(mainQuestionArray)
//        day = nowDate(num: 0)
//        questionArray = mainQuestionArray[day]!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListTableViewCell") as! TopListTableViewCell
        if let title = questionArray[indexPath.row].title{
            cell.contentLabel.text = title
            cell.subLabel.textColor = UIColor.hex(string: "#1167C0", alpha: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        performSegue(withIdentifier: "a", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "a"{
            let pastResultViewController = segue.destination as! PastResultViewController
            let ques = [String](self.questionArray[num].array.values)
            pastResultViewController.questionArray = ques
            pastResultViewController.question = self.questionArray[num]
//            pastResultViewController.day = self.day
        }
    }
}
