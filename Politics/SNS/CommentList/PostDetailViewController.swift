//
//  PostDetailViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/16.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class PostDetailViewController: FormViewController  {
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Multivalued Examples"
        
        
        form +++ Section()
            +++ Section("投稿内容")
            <<< TextRow("title"){
                $0.placeholder = "title"
            }
            
            <<< TextAreaRow("notes") {
                $0.placeholder = "Notes"
                $0.title = "本文"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 150)
        }
        
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "タグ付け") {
                                $0.tag = "textfields"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New Tag"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                    
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    //
                                    return NameRow() {
                                        $0.placeholder = "Tag Name"
                                    }
                                }
                                
                                $0 <<< NameRow() {
                                    $0.placeholder = "Tag Name"
                                }
        }
        
        form +++
            Section()
            <<< ButtonRow(){
                $0.title = "投稿する"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection(){i, to in
                    let values = self.form.values()
                    print(values)
                    if let title:String = values["title"] as? String,let content:String = values["notes"] as? String{
                        let tagArray:[String] = (values["textfields"] as? [String])!
                        var dateTagArray = [String:Int64]()
                        let date  = NSDate()
                        let int64 = date.toInt64()
                        print(int64)
                        for tag in tagArray{
                            print(tag)
                            dateTagArray["\(tag)"] = int64
                        }
                        let user = self.realm.objects(Userdata.self)
                        print(dateTagArray)
                        if tagArray.count != 0{
                            let postContent = PostDetail(title: title, contents: content, tagArray: dateTagArray, uid: user[0].userID, username: user[0].name, date: date)
                            self.db.collection("SNS").addDocument(data: [
                                "title": postContent.title,
                                "content": postContent.contents,
                                "tags": postContent.tagArray,
                                "uid": postContent.uid,
                                "name": postContent.username,
                                "date": postContent.date
                                ])
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            let postContentWithoutTag = PostDetail(title: title, contents: content, tagArray: ["何もありません" : int64], uid: user[0].userID, username: user[0].name, date: date)
                            self.db.collection("SNS").addDocument(data: [
                                "title": postContentWithoutTag.title,
                                "content": postContentWithoutTag.contents,
                                "tags": postContentWithoutTag.tagArray,
                                "uid": postContentWithoutTag.uid,
                                "name": postContentWithoutTag.username,
                                "date": postContentWithoutTag.date
                                ])
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }else{
                        self.alert(message: "titleとnoteは必ず入力してください")
                    }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
