//
//  TodayResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import SwiftDate
class TodayResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var mainTable: UITableView!
    var mainQuestionArray = [String:[Qusetions]]()
    var questionArray = [Qusetions]()
    var num:Int!
    var day:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mainQuestionArray = appDelegate.mainQuestionArray
        print(mainQuestionArray)
         day = nowDate(num: 0)
        questionArray = mainQuestionArray[day]!
       

        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = questionArray[indexPath.row].title
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
            pastResultViewController.questionArray = self.questionArray[num].array
            pastResultViewController.questionID = self.questionArray[num].questionID
            pastResultViewController.day = self.day
        }
    }
    


}
