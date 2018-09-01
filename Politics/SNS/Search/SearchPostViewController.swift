//
//  SearchPostViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/02.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class SearchPostViewController: FormViewController {
    var resarchContent:GetDetail!
    let db = Firestore.firestore()
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = self.realm.objects(Userdata.self)
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
                        self.db.collection("SNS").document(self.resarchContent.docID).collection("response").addDocument(data: [
                            "comment" : note,
                            "date":NSDate(),
                            "name":user[0].name,
                            "uid":user[0].userID
                        ]){error in
                            if let error = error{
                                self.alert(message: error.localizedDescription)
                            }else{
                                self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                            }
                        }
                    }else{
                        self.alert(message: "何か入力してください")
                    }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
