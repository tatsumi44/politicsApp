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
class ReguralyViewController: FormViewController {
    let array = ["abc","def","ghi","jkl","mno",]
    let db = Firestore.firestore()
    var questionArray = [Qusetions]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("questions").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                for doc in snap!.documents{
                    let data = doc.data()
                    self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: doc.documentID))
                }
                self.createNormalForm(forms: self.questionArray)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNormalForm(forms: [Qusetions]){
        form = Section("定期投票を行うには、ONにして下さい")
            <<< SwitchRow("Show Next Section") {
                $0.title = "SwitchRow"
                $0.value = false
            }
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
                        $0.title = item.title
                        $0.options = item.array
                        $0.value = ""
                        $0.selectorTitle = "Choose an Emoji!"
                        }.onChange({ (row) in
                            print(row.value)
                        })
                        .onPresent { from, to in
                            to.dismissOnSelection = false
                            to.dismissOnChange = false
                }
            }
        }
    }
}
