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
    var url:String!
    var postedContent: GetDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        title = "投稿する"
        
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
                                    return TextRow() {
                                        $0.placeholder = "Tag Name"
                                    }
                                }
                                
                                $0 <<< TextRow() {
                                    $0.placeholder = "Tag Name"
                                }
        }
        
        form +++
            Section()
            <<< URLRow("url") {
                $0.title = "URL"
                $0.placeholder = "URLを入力"
//                $0.value = URL(string: "http://xmartlabs.com")
            }
            <<< ButtonRow(){
                $0.title = "投稿する"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection(){i, to in
                    let values = self.form.values()
                    print(values)
//                    print("url : \(values["url"] as? URL)")
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
//                        print("url : \(values["url"] as? URL)")
                        if let sample = values["url"] as? URL {
                            self.url = sample.absoluteString
                            print(self.url )
                        }else{
                            self.url = ""
                        }
                        let user = self.realm.objects(Userdata.self)
                        print(dateTagArray)
                        if tagArray.count != 0{
                            let postContent = PostDetail(title: title, contents: content, tagArray: dateTagArray, uid: user[0].userID, username: user[0].name, url: self.url, date: date)
                            var ref: DocumentReference? = nil
                            ref = self.db.collection("SNS").addDocument(data: [
                                "title": postContent.title,
                                "content": postContent.contents,
                                "tags": postContent.tagArray,
                                "uid": postContent.uid,
                                "name": postContent.username,
                                "url":postContent.url,
                                "date": postContent.date
                            ]){error in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{
                                    self.postedContent = GetDetail(num: 0, title: title, contents: content, tagArray: dateTagArray, uid: user[0].userID,username: user[0].name, docID: ref!.documentID, url: self.url, likeCount: 0, disLikeCount: 0, commentCount: 0, date: NSDate())
                                    let sns = SNSVote()
                                    sns.snsID = ref!.documentID
                                    sns.snsDate = Date()
                                    try! self.realm.write() {
                                        self.realm.add(sns)
                                    }
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }

                        }else{
                            let postContentWithoutTag = PostDetail(title: title, contents: content, tagArray: ["何もありません" : int64], uid: user[0].userID, username: user[0].name, url: self.url, date: date)
                             var ref: DocumentReference? = nil
                            ref = self.db.collection("SNS").addDocument(data: [
                                "title": postContentWithoutTag.title,
                                "content": postContentWithoutTag.contents,
                                "tags": postContentWithoutTag.tagArray,
                                "uid": postContentWithoutTag.uid,
                                "name": postContentWithoutTag.username,
                                "url":postContentWithoutTag.url,
                                "date": postContentWithoutTag.date
                            ]){error in
                                if let error = error{
                                    print(error.localizedDescription)
                                }else{

                                    self.postedContent = GetDetail(num: 0, title: postContentWithoutTag.title, contents: postContentWithoutTag.contents, tagArray: postContentWithoutTag.tagArray, uid: user[0].userID,username: user[0].name, docID: ref!.documentID, url: self.url, likeCount: 0, disLikeCount: 0, commentCount: 0, date: NSDate())
                                    let sns = SNSVote()
                                    sns.snsID = ref!.documentID
                                    sns.snsDate = Date()
                                    try! self.realm.write() {
                                        self.realm.add(sns)
                                    }
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
//                            self.navigationController?.popToRootViewController(animated: true)
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
extension PostDetailViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print(self.postedContent)
        //        content.commentCount = responseArray.count
        // 遷移先が、AViewControllerだったら……
        if let controller = viewController as? SNSListViewController {
            print("いくデー")
            // AViewControllerのプロパティvalueの値変更。
            controller.postedContent = self.postedContent

        }
    }
}
