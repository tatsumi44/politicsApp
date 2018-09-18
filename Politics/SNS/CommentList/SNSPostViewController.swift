//
//  SNSPostViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/27.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class SNSPostViewController: FormViewController {
    
    var content:GetDetail!
    let db = Firestore.firestore()
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = self.realm.objects(Userdata.self)
        let response = realm.objects(SNSResponse.self)
        title = "コメントする"
        form +++ Section("コメントする")
            <<< TextAreaRow("notes") {
                $0.placeholder = "Notes"
                $0.title = "本文"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 250)
            }
            <<< ButtonRow(){
                $0.title = "コメントする"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection(){i, to in
                    let values = self.form.values()
                    print(values)
                    if let note:String = values["notes"] as? String{
                        print(note)
                        self.db.collection("SNS").document(self.content.docID).collection("response").addDocument(data: [
                            "comment" : note,
                            "date":NSDate(),
                            "name":user[0].name,
                            "uid":user[0].userID
                        ]){error in
                            if let error = error{
                                self.alert(message: error.localizedDescription)
                            }else{
                                print("成功")
                                if response.count != 0{
                                    if response.filter("snsID == %@",self.content.docID).count != 0{
                                        let response1 = response.filter("snsID == %@",self.content.docID)[0]
                                        try! self.realm.write() {
                                            response1.snsID = self.content.docID
                                            response1.snsDate = Date()
                                        }
                                        
                                    }else{
                                        let response = SNSResponse()
                                        response.snsID = self.content.docID
                                        response.snsDate = Date()
                                        try! self.realm.write() {
                                            self.realm.add(response)
                                        }
                                    }
                                }else{
                                    let response = SNSResponse()
                                    response.snsID = self.content.docID
                                    response.snsDate = Date()
                                    try! self.realm.write() {
                                        self.realm.add(response)
                                    }
                                }
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }else{
                        self.alert(message: "何か入力してください")
                    }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
