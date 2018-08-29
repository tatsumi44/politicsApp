//
//  SearchListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/19.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import WCLShineButton
import RealmSwift
import Firebase
class SearchListViewController: ViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    var resarchContents = [GetDetail]()
    var num:Int!
    var goodArray = [String]()
    var badArray = [String]()
    let realm = try! Realm()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        self.mainTable.register(UINib(nibName: "SNSTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let likes = realm.objects(MyLikes.self)
        goodArray = [String]()
        badArray = [String]()
        likes.forEach { (like) in
            goodArray.append(like.documentID)
        }
        let dislikes = realm.objects(MyDisLikes.self)
        dislikes.forEach { (dislike) in
            badArray.append(dislike.documentID)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resarchContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SNSTableViewCell
        cell.tag = indexPath.row + 1
        cell.nameLabel.text = resarchContents[indexPath.row].username
        cell.titleLabel.text = resarchContents[indexPath.row].title
        cell.contentLabel.text = resarchContents[indexPath.row].contents
        var param2 = WCLShineParams()
        param2.bigShineColor = UIColor(rgb: (255, 195, 55))
        cell.likebtn.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
        cell.likebtn.params = param2
        cell.likebtn.tag = indexPath.row
        cell.likebtn.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
        if self.goodArray.index(of:resarchContents[indexPath.row].docID ) != nil{
            cell.likebtn.isSelected = true
        }else{
            cell.likebtn.isSelected = false
        }
        var param3 = WCLShineParams()
        param3.bigShineColor = UIColor(rgb: (18, 255, 255))
        cell.dislikebtn.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
        cell.dislikebtn.params = param3
        cell.dislikebtn.tag = indexPath.row
        cell.dislikebtn.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
        if self.badArray.index(of: resarchContents[indexPath.row].docID) != nil{
            cell.dislikebtn.isSelected = true
        }else{
            cell.dislikebtn.isSelected = false
        }
        cell.commentBtn.imageView?.image = UIImage(named: "comment1")
        var keys = [String](resarchContents[indexPath.row].tagArray.keys)
        print(keys)
        switch keys.count {
        case 1:
            cell.label1.text = keys[0]
            cell.label2.isHidden = true
            cell.label3.isHidden = true
        case 2:
            cell.label1.text = keys[0]
            cell.label2.text = keys[1]
            cell.label3.isHidden = true
        default:
            cell.label1.text = keys[0]
            cell.label2.text = keys[1]
            cell.label3.text = keys[2]
        }
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self, action: #selector(self.commentTap(sender:)), for: .touchUpInside)
        cell.commenNum.text = "\(resarchContents[indexPath.row].commentCount!) comments"
        cell.likeNum.text = "\(resarchContents[indexPath.row].likeCount!) good"
        cell.disLikeNum.text = "\(resarchContents[indexPath.row].disLikeCount!) bad"
        return cell
    }
    @objc func commentTap(sender:UIButton){
        num = sender.tag
        performSegue(withIdentifier: "SearchResultDetail", sender: nil)
    }
    @objc func likeTap(sender: WCLShineButton){
        
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(resarchContents[sender.tag].docID).collection("good").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = MyLikes()
                    likes.documentID = self.resarchContents[sender.tag].docID
                    try! self.realm.write() {
                        self.realm.add(likes)
                        //セルのもう片方が選択されている場合の条件追加
                        if self.badArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                            self.db.collection("SNS").document(self.resarchContents[sender.tag].docID).collection("bad").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.resarchContents[sender.tag].docID)
                                    try! self.realm.write() {
                                        self.realm.delete(dislikes)
                                        if self.badArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                                            self.badArray.remove(at: self.badArray.index(of: self.resarchContents[sender.tag].docID)!)
                                        }
                                        self.goodArray.append(self.resarchContents[sender.tag].docID)
                                        self.resarchContents[sender.tag].likeCount = self.resarchContents[sender.tag].likeCount + 1
                                        self.resarchContents[sender.tag].disLikeCount = self.resarchContents[sender.tag].disLikeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.goodArray.append(self.resarchContents[sender.tag].docID)
                            self.resarchContents[sender.tag].likeCount = self.resarchContents[sender.tag].likeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                    print("ドキュメント追加")
                }
            }
        }else{
            //dbから削除
            db.collection("SNS").document(resarchContents[sender.tag].docID).collection("good").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.resarchContents[sender.tag].docID)
                    try! self.realm.write() {
                        self.realm.delete(likes)
                        if self.goodArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                            self.goodArray.remove(at: self.goodArray.index(of: self.resarchContents[sender.tag].docID)!)
                        }
                        self.resarchContents[sender.tag].likeCount = self.resarchContents[sender.tag].likeCount - 1
                        let row = NSIndexPath(row: sender.tag, section: 0)
                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                    }
                    print("ドキュメント削除")
                }
            }
        }
        print("Clicked \(sender.isSelected)")
        
    }
    @objc func dislikeTap(sender: WCLShineButton){
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(resarchContents[sender.tag].docID).collection("bad").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = MyDisLikes()
                    dislikes.documentID = self.resarchContents[sender.tag].docID
                    
                    try! self.realm.write() {
                        self.realm.add(dislikes)
                        if self.goodArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                            self.db.collection("SNS").document(self.resarchContents[sender.tag].docID).collection("good").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.resarchContents[sender.tag].docID)
                                    try! self.realm.write() {
                                        self.realm.delete(likes)
                                        if self.goodArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                                            self.goodArray.remove(at: self.goodArray.index(of: self.resarchContents[sender.tag].docID)!)
                                        }
                                        self.badArray.append(self.resarchContents[sender.tag].docID)
                                        self.resarchContents[sender.tag].disLikeCount = self.resarchContents[sender.tag].disLikeCount + 1
                                        self.resarchContents[sender.tag].likeCount = self.resarchContents[sender.tag].likeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.badArray.append(self.resarchContents[sender.tag].docID)
                            self.resarchContents[sender.tag].disLikeCount = self.resarchContents[sender.tag].disLikeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                    print("ドキュメント追加")
                }
            }
        }else{
            //dbから削除
            db.collection("SNS").document(resarchContents[sender.tag].docID).collection("bad").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.resarchContents[sender.tag].docID)
                    try! self.realm.write() {
                        self.realm.delete(dislikes)
                        if self.badArray.index(of: self.resarchContents[sender.tag].docID) != nil{
                            self.badArray.remove(at: self.badArray.index(of: self.resarchContents[sender.tag].docID)!)
                        }
                        self.resarchContents[sender.tag].disLikeCount = self.resarchContents[sender.tag].disLikeCount - 1
                        let row = NSIndexPath(row: sender.tag, section: 0)
                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                    }
                    print("ドキュメント削除")
                }
            }
        }
        print("Clicked \(sender.isSelected)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultDetail"{
            let searchDetailViewController = segue.destination as! SearchDetailViewController
            searchDetailViewController.content = resarchContents[num]
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
