//
//  ReguralyViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/11.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class ReguralyViewController: FormViewController {
    let array = ["abc","def","ghi","jkl","mno",]
    let db = Firestore.firestore()
    let realm = try! Realm()
    var questionArray = [Qusetions]()
    var num = 0
    var resultArray = [RegularResult]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let data = realm.objects(RegularVoteResult.self)
//        try! realm.write() {
//            realm.delete(data)
//        }
//
        
//        db.collection("questions").getDocuments { (snap, error) in
//            if let error = error{
//                self.alert(message: error.localizedDescription)
//            }else{
//                for doc in snap!.documents{
//                    let data = doc.data()
//                    self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: doc.documentID))
//                }
//                self.createNormalForm(forms: self.questionArray)
//            }
//        }
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        questionArray = appDelegate.questionArray
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultArray = [RegularResult]()
        let results = realm.objects(RegularVoteResult.self)
        results.forEach { (result) in
            resultArray.append(RegularResult(questionID: result.questionID, QuestionAnswer: result.questionAnswer))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNormalForm(forms: [Qusetions]){
        form = Section("定期投票を行うには、ONにして下さい")
            <<< SwitchRow("Show Next Section") {
                $0.title = "定期投票の設定をして下さい"
                let flag = realm.objects(RegularVote.self).first
                let flag1 = realm.objects(RegularVote.self)
                print(flag1.count)
                if flag1.count != 0{
                    $0.value = flag?.flag
                }else{
                    $0.value = false
                }
                
                }.onChange({ (diff) in
//                                        print(diff.value)
                    let user = self.realm.objects(Userdata.self)
                    let flag = self.realm.objects(RegularVote.self).first
                    let flag1 = self.realm.objects(RegularVote.self)
                    if flag1.count != 0{
                        try! self.realm.write() {
                            flag?.flag = diff.value!
                            print(user[0].userID)
                            self.db.collection("users").document(user[0].userID).updateData([
                                "regularFlag" : diff.value!,
                                "regularFlagDate": NSDate()
                                ])
                        }
                    }else{
                        let flag = RegularVote()
                        flag.flag = diff.value!
                        print(diff.value!)
                        try! self.realm.write() {
                            self.realm.add(flag)
                        }
                    }
                })
            +++ Section("投票一覧"){
                $0.tag = "sec2"
                $0.hidden = .function(["Show Next Section"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Show Next Section")
                    return row.value ?? false == false
                })
        }
        
        if let section = form.sectionBy(tag: "sec2") { //tagからSection2を取得
            forms.forEach { item in
                section
                    <<< PushRow<String>(item.title) {
                        $0.tag = "\(num)"
                        let tagNum:Int = Int($0.tag!)!
                        if resultArray.filter({$0.questionID == self.questionArray[tagNum].questionID}).count != 0{
                            $0.value = resultArray.filter({$0.questionID == self.questionArray[tagNum].questionID})[0].QuestionAnswer
                        }else{
                            $0.value = ""
                        }
                        $0.title = item.title
//                        $0.options = item.array
                        $0.selectorTitle = "Choose an Emoji!"
                        num += 1
                        }.onChange({ (row) in
                            let user = self.realm.objects(Userdata.self)
                            let result = RegularVoteResult()
//                            print(row.value)
//                            print(row.tag)
                            let tagNum:Int = Int(row.tag!)!
                            if self.realm.objects(RegularVoteResult.self).filter("questionID == %@",self.questionArray[tagNum].questionID).count != 0{
                                let data = self.realm.objects(RegularVoteResult.self).filter("questionID == %@",self.questionArray[tagNum].questionID).first
                                try! self.realm.write() {
                                    data?.questionAnswer = row.value!
                                    self.db.collection("users").document(user[0].userID).updateData([
                                        self.questionArray[tagNum].questionID : row.value!
                                        ])
                                }
                                
                            }else{
                                result.questionID = self.questionArray[tagNum].questionID
                                result.questionTitle = row.title!
                                result.questionAnswer = row.value!
                                try! self.realm.write() {
                                    self.realm.add(result)
                                    self.db.collection("users").document(user[0].userID).updateData([
                                        self.questionArray[tagNum].questionID : row.value!
                                        ])
                                }
                            }

                        })
                        .onPresent { from, to in
                            to.dismissOnSelection = false
                            to.dismissOnChange = false
                }
            }
        }
    }
}
