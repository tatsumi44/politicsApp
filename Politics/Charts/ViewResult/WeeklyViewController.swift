//
//  WeeklyViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/05.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
class WeeklyViewController: UIViewController {
    let db = Firestore.firestore()
    var questionArray = [Qusetions]()
    var contentsArray = [WeeklyData]()
    //    var maincontentsArray = [mainWeeklyData]()
    var num:Int = 0
    var selectNum:Int!
    var question = [Qusetions]()
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        mainTable.dataSource = self
        mainTable.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        questionArray = appDelegate.questionArray
        self.mainTable.register(UINib(nibName: "TopListTableViewCell", bundle: nil), forCellReuseIdentifier: "TopListTableViewCell")
        print(questionArray)
        for qes in questionArray{
//            let qesIDs = qes.questionID
            let ansIDs = Array([String](qes.array.keys))
//            print(qesIDs)
            guard let qesIDs = qes.questionID else{
                return
            }
            print(ansIDs)
            for i in 1...7{
                db.collection(nowDate(num: i)).document("weekly_data").collection("weekly_data").document(qesIDs).getDocument { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        let data = snap?.data()
                        //                        print("\(qes.questionID)=>\(self.nowDate(num: i))=>\(data?["answer_size"])")
//                        let answer:[String] = data!["answer"] as! [String]
                        let answer_size:[String:Int] = data?["answer_size"] as! [String : Int]
                        let sum = [Int](answer_size.values)
                        self.contentsArray.append(WeeklyData(questionID: (snap?.documentID)!, answers: ansIDs, answerSize: answer_size, num: i, sum: sum.reduce(0, {$0+$1})))
                        print(sum.reduce(0, {$0+$1}))
                        if self.contentsArray.count == 7{
                            HUD.hide()
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension WeeklyViewController:UITableViewDataSource,UITableViewDelegate{
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
        selectNum = indexPath.row
        performSegue(withIdentifier: "GoWeekly", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoWeekly"{
            let detailWeeklyViewController = segue.destination as! DetailWeeklyViewController
            //                if self.contentsArray.filter({$0.questionID == question[selectNum].questionID}).count != 0{
            detailWeeklyViewController.contentsArray = self.contentsArray.filter({$0.questionID == questionArray[selectNum].questionID})
            detailWeeklyViewController.question = self.questionArray[selectNum]
            //                }else{
            //                    self.alert(message: "この一週間で投票されたデータはありません")
            //                }
        }
    }
    
}

