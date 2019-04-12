//
//  PublicVotePostViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2019/02/01.
//  Copyright © 2019 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class PublicVotePostViewController: FormViewController {
    let db = Firestore.firestore()
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("アンケート内容")
            <<< TextAreaRow("title") {
                $0.placeholder = "あなたがアンケートをた取りたい政治的な質問を入力してください。"
                $0.title = "本文"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 150)
        }
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "アンケートの選択肢を入力してください") {
                                $0.tag = "choices"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "選択肢を追加"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                    
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    //
                                    return TextRow() {
                                        $0.placeholder = "選択肢\(index + 1)"
                                    }
                                }
                                
                                $0 <<< TextRow() {
                                    
                                    $0.placeholder = "選択肢1"
                                }
        }
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "タグ付け") {
                                $0.tag = "tags"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "タグの追加"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                    
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    //
                                    return TextRow() {
                                        $0.placeholder = "Tag Name"
                                    }
                                }
                                
                                $0 <<< TextRow() {
                                    $0.placeholder = "Tag Name"
                                }
        }
        form +++
            Section("アンケートを追加する")
            <<< ButtonRow(){
                $0.title = "投稿する"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection(){i, to in
                    let values = self.form.values()
                    print(values)
                    let choices:[String] = values["choices"] as! [String]
                    let tagArray:[String] = (values["tags"] as? [String])!
                    print(choices)
                    var dateTagArray = [String:Int64]()
                    let date  = NSDate()
                    let int64 = date.toInt64()
                    guard let title:String = values["title"] as? String else{
                        self.alert(message: "アンケート内容は必ず入力してください")
                        return
                    }
                    guard choices.count >= 2 else{
                        self.alert(message: "選択肢は二つ以上入力してください")
                        return
                    }
                    guard tagArray.count != 0 else{
                        self.alert(message: "少なくとも一つ入力してください")
                        return
                    }
                    for tag in tagArray{
                        dateTagArray["\(tag)"] = int64
                    }
                    var ref: DocumentReference? = nil
                    ref = self.db.collection("PublicVote").addDocument(data: [
                        "main_title" : title,
                        "tags" : dateTagArray,
                        "date":Date()
                    ]){error in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            let docID = ref?.documentID
                            for choice in choices{
                                self.db.collection("PublicVote").document(docID!).collection("answer").addDocument(data: [
                                    "answer" : choice
                                ]){error in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                    }else{
                                        self.alert1(message: "質問の投稿が完了しました")
                                    }
                                }
                            }
                        }
                    }
        }
        
    }
    
}
