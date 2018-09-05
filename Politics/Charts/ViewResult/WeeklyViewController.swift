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
        for i in 0..<7{
            db.collection("questions").whereField("\(nowDate(num: i))", isEqualTo: true).getDocuments { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                    HUD.hide()
                }else{
                    for doc in snap!.documents{
                        self.contentsArray.append(weeklyData(docID: doc.documentID, title: doc["main_title"] as! String, questions: doc["question_array"] as! [String]))
                    }
                    for content in self.contentsArray{
                        self.num = self.num + content.questions.count
                        for question in content.questions{
                            self.db.collection("\(self.nowDate(num: i))").document(content.docID).collection(question).getDocuments(completion: { (snap, error) in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                    HUD.hide()
                                }else{
                                    self.maincontentsArray.append(mainWeeklyData(docID: content.docID, title: content.title, question: question, questionCount: (snap?.count)!, date: self.nowDate(num: i)))
                                }
                                if self.maincontentsArray.count == self.num{
                                    let array = self.maincontentsArray.filter({$0.docID == self.contentsArray[1].docID}).filter({$0.date == self.nowDate(num: 4)})
//                                    print(array)
                                    HUD.hide()
                                    
                                }
                            })
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
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoWeekly"{
            let detailWeeklyViewController = segue.destination as! DetailWeeklyViewController
            if self.maincontentsArray.filter({$0.docID == question[selectNum].questionID}).count != 0{
                detailWeeklyViewController.maincontentsArray = self.maincontentsArray.filter({$0.docID == question[selectNum].questionID})
            }else{
                self.alert(message: "この一週間で投票されたデータはありません")
            }
        }
    }
    
    
}
