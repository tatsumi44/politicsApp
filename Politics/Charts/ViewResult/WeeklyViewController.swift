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
    var mainQuestionArray = [String:[Qusetions]]()
    var contentsArray = [weeklyData]()
    var maincontentsArray = [mainWeeklyData]()
    var num:Int = 0
    var selectNum:Int!
    var question = [Qusetions]()
    
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        mainTable.dataSource = self
        mainTable.delegate = self
        db.collection("questions").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                for doc in snap!.documents{
                    self.question.append(Qusetions(array: doc["question_array"] as! [String], title: doc["main_title"] as! String, questionID: doc.documentID))
                }
                self.mainTable.reloadData()
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        mainQuestionArray = appDelegate.mainQuestionArray
        print(mainQuestionArray)
        for i in 0..<7{
            //その日の投票されているデータget
            if let array = mainQuestionArray[nowDate(num: i)]{
                for content in array{
                    num = num + content.array.count
                    print(num)
                    for ques in content.array{
                        db.collection(nowDate(num: i)).document(content.questionID).collection(ques).getDocuments { (snap, error) in
                            if let error = error{
                                self.alert(message: error.localizedDescription)
                            }else{
                                self.db.collection("users").whereField("regularFlag", isEqualTo: true).whereField(content.questionID, isEqualTo: ques).getDocuments(completion: { (snap1, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                    }else{
                                        self.maincontentsArray.append(mainWeeklyData(docID: content.questionID, title: content.title, question: ques, questionCount: (snap!.count + snap1!.count), date: self.nowDate(num: i)))
                                    }
                                    if self.maincontentsArray.count == self.num{
                                        HUD.hide()
                                    }
                                })
                            }
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
        return question.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyCell", for: indexPath)
        cell.textLabel?.text = question[indexPath.row].title
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
            if self.maincontentsArray.filter({$0.docID == question[selectNum].questionID}).count != 0{
                detailWeeklyViewController.maincontentsArray = self.maincontentsArray.filter({$0.docID == question[selectNum].questionID})
                detailWeeklyViewController.question = self.question[selectNum]
            }else{
                self.alert(message: "この一週間で投票されたデータはありません")
            }
        }
    }
    
    
}
