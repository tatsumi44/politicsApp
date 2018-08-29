//
//  NewsPostCommentViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class NewsPostCommentViewController: FormViewController {
    var newsContents:NewsData!
    var date:String!
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
                        self.db.collection("news").document(self.date).collection(self.newsurlPath(newsURL: self.newsContents.url)).addDocument(data: [
                            "comment" : note,
                            "date": NSDate(),
                            "title": self.newsContents.title,
                            "url": self.newsContents.url,
                            "uid": user[0].userID,
                            "username":user[0].name,
                            "userImagePath": "/"
                            ])
                        self.navigationController?.popToRootViewController(animated: true)
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
