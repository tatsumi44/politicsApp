//
//  VoteListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import RealmSwift
class VoteListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let db = Firestore.firestore()
    var questionArray = [Qusetions]()
    var num: Int!
    let realm = try! Realm()
    var flag:Bool!
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
        mainTable.dataSource = self
        mainTable.delegate  = self
//        let realm = try! Realm()
//        let tanakas = realm.objects(Vote.self)
//
//        tanakas.forEach { tanaka in
//            try! realm.write() {
//                realm.delete(tanaka)
//            }
//        }
        db.collection("questions").getDocuments { (snap, error) in
            for content in snap!.documents{
                let data = content.data()
                //                print(data)
                self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: content.documentID))
            }
            self.mainTable.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = questionArray[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        let result = realm.objects(Vote.self).filter("questionID == %@",self.questionArray[num].questionID)
        if result.count != 0{
//            let result1 = realm.objects(Vote.self).last
//            print(result1!.voteDate)
//            let f = DateFormatter()
//            f.dateFormat = "yyyy/MM/dd"
//            let tomorrow: Date = Date(timeIntervalSinceNow: 60*60*9)
//            if f.string(from: result1!.voteDate) == f.string(from: tomorrow){
//                self.alert(message: "投票内容を変更しますか？")
                let alert: UIAlertController = UIAlertController(title: "本日は投票されています", message: "投票内容を変更しますか？", preferredStyle:  UIAlertControllerStyle.alert)

                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                    self.flag = true
                    print(self.flag)
                    self.performSegue(withIdentifier: "GoVote", sender: nil)
                    if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                        tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
                    }
                })
                // キャンセルボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
//
//            }else{
//                flag = false
//                performSegue(withIdentifier: "GoVote", sender: nil)
//                if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
//                    tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
//                }
//            }
//            print(tomorrow)
        }else{
            flag = false
            print(self.flag)
            performSegue(withIdentifier: "GoVote", sender: nil)
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoVote"{
            let voteviewController = segue.destination as! VoteViewController
            voteviewController.questions = self.questionArray[num]
            voteviewController.flag = self.flag
        }
    }
    

}
