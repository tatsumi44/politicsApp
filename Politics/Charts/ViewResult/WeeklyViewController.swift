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
        print(questionArray)
        for qes in questionArray{
            for i in 1...7{
                db.collection(nowDate(num: i)).document("weekly_data").collection("weekly_data").document(qes.questionID).getDocument { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        let data = snap?.data()
                        //                        print("\(qes.questionID)=>\(self.nowDate(num: i))=>\(data?["answer_size"])")
                        let answer:[String] = data!["answer"] as! [String]
                        let answer_size:[String:Int] = data?["answer_size"] as! [String : Int]
                        self.contentsArray.append(WeeklyData(questionID: (snap?.documentID)!, answers: answer, answerSize: answer_size, num: i))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyCell", for: indexPath)
        cell.textLabel?.text = questionArray[indexPath.row].title
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

