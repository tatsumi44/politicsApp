//
//  SNSEvaluationViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/17.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import WCLShineButton
import SafariServices
import RealmSwift
import PKHUD
class SNSEvaluationViewController: UIViewController {
    @IBOutlet weak var mainTable: UITableView!
    var evaluationList:[String]!
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let realm = try! Realm()
    var contents = [GetDetail]()
    var goodArray = [String]()
    var badArray = [String]()
    var num = 0
    var postNum:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(evaluationList)
        mainTable.dataSource = self
        mainTable.delegate = self
        self.mainTable.register(UINib(nibName: "SNSTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        self.mainTable.register(UINib(nibName: "SNSwithUrlTableViewCell", bundle: nil), forCellReuseIdentifier: "SNSwithUrlTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData()  {
        HUD.show(.progress)
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
        contents = [GetDetail]()
        for evaluation in evaluationList{
            db.collection("SNS").document(evaluation).getDocument { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    if let snap = snap,let data = snap.data(){
                        self.db.collection("SNS").document(evaluation).collection("good").getDocuments(completion: { (snap, error) in
                            if let error = error{
                                self.alert(message: error.localizedDescription)
                            }else{
                                let good = snap?.count
                                self.db.collection("SNS").document(evaluation).collection("bad").getDocuments(completion: { (snap, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                    }else{
                                        let bad = snap?.count
                                        self.db.collection("SNS").document(evaluation).collection("response").getDocuments(completion: { (snap, error) in
                                            if let error = error{
                                                self.alert(message: error.localizedDescription)
                                            }else{
                                                let response = snap?.count
                                                self.contents.append(GetDetail(num: self.num, title: data["title"] as! String, contents: data["content"] as! String, tagArray: data["tags"] as! [String : Int64], uid: data["uid"] as! String, username: data["name"] as! String, docID: evaluation, url: data["url"] as! String, likeCount: good!, disLikeCount: bad!, commentCount: response!, date: data["date"] as! NSDate))
                                            }
                                            self.num += 1
                                            if self.contents.count == self.evaluationList.count{
                                                self.contents.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                self.mainTable.reloadData()
                                                print(self.contents)
                                                HUD.hide()
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SNSEvaluationViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contents[indexPath.row].url {
        case "":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SNSTableViewCell
            cell.tag = indexPath.row
            let reference = storageRef.child("image/profile/\(self.contents[indexPath.row].uid!).jpg")
            cell.userImage.layer.cornerRadius = 25
            cell.userImage.layer.masksToBounds = true
            cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.nameLabel.text = self.contents[indexPath.row].username
            cell.titleLabel.text = self.contents[indexPath.row].title
            cell.contentLabel.text = self.contents[indexPath.row].contents
            var param2 = WCLShineParams()
            param2.bigShineColor = UIColor(rgb: (255, 195, 55))
            cell.likebtn.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
            cell.likebtn.params = param2
            cell.likebtn.tag = indexPath.row
            
            if self.goodArray.index(of:contents[indexPath.row].docID ) != nil{
                cell.likebtn.isSelected = true
            }else{
                cell.likebtn.isSelected = false
            }
            cell.likebtn.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
            var param3 = WCLShineParams()
            param3.bigShineColor = UIColor(rgb: (18, 255, 255))
            cell.dislikebtn.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
            cell.dislikebtn.params = param3
            cell.dislikebtn.tag = indexPath.row
            
            if self.badArray.index(of: contents[indexPath.row].docID) != nil{
                cell.dislikebtn.isSelected = true
            }else{
                cell.dislikebtn.isSelected = false
            }
            cell.dislikebtn.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
            cell.commentBtn.imageView?.image = UIImage(named: "comment1")
            let content = self.contents[indexPath.row].tagArray
            var keys = [String](content!.keys)
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
            cell.commenNum.text = "\(contents[indexPath.row].commentCount!) comments"
            cell.likeNum.text = "\(contents[indexPath.row].likeCount!) good"
            cell.disLikeNum.text = "\(contents[indexPath.row].disLikeCount!) bad"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SNSwithUrlTableViewCell", for: indexPath) as! SNSwithUrlTableViewCell
            cell.tag = indexPath.row
            let reference = storageRef.child("image/profile/\(self.contents[indexPath.row].uid!).jpg")
            print("image/profile/\(self.contents[indexPath.row].uid!).jpg")
            cell.userImage.layer.cornerRadius = 25
            cell.userImage.layer.masksToBounds = true
            cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.nameLabel.text = self.contents[indexPath.row].username
            cell.titleLabel.text = self.contents[indexPath.row].title
            cell.contentLabel.text = self.contents[indexPath.row].contents
            var param2 = WCLShineParams()
            param2.bigShineColor = UIColor(rgb: (255, 195, 55))
            cell.likeBtn.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
            cell.likeBtn.params = param2
            cell.likeBtn.tag = indexPath.row
            
            if self.goodArray.index(of:contents[indexPath.row].docID ) != nil{
                cell.likeBtn.isSelected = true
            }else{
                cell.likeBtn.isSelected = false
            }
            cell.likeBtn.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
            var param3 = WCLShineParams()
            param3.bigShineColor = UIColor(rgb: (18, 255, 255))
            cell.disLikeBtn.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
            cell.disLikeBtn.params = param3
            cell.disLikeBtn.tag = indexPath.row
            
            if self.badArray.index(of: contents[indexPath.row].docID) != nil{
                cell.disLikeBtn.isSelected = true
            }else{
                cell.disLikeBtn.isSelected = false
            }
            cell.disLikeBtn.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
            cell.commentBtn.imageView?.image = UIImage(named: "comment1")
            let content = self.contents[indexPath.row].tagArray
            var keys = [String](content!.keys)
            print(keys)
            switch keys.count {
            case 1:
                cell.tag1Label.text = keys[0]
                cell.tag2Label.isHidden = true
                cell.tag3Label.isHidden = true
            case 2:
                cell.tag1Label.text = keys[0]
                cell.tag2Label.text = keys[1]
                cell.tag3Label.isHidden = true
            default:
                cell.tag1Label.text = keys[0]
                cell.tag2Label.text = keys[1]
                cell.tag3Label.text = keys[2]
                
            }
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(self.commentTap(sender:)), for: .touchUpInside)
            cell.commnetCount.text = "\(contents[indexPath.row].commentCount!) comments"
            cell.likeCount.text = "\(contents[indexPath.row].likeCount!) good"
            cell.disLikeCount.text = "\(contents[indexPath.row].disLikeCount!) bad"
            cell.urlLabel.text = contents[indexPath.row].url
            cell.urlBtn.tag = indexPath.row
            cell.urlBtn.addTarget(self, action: #selector(self.urlTap(sender:)), for: .touchUpInside)
            return cell
        }
    }
    @objc func urlTap(sender:UIButton){
        if let url = NSURL(string: contents[sender.tag].url) {
            let safariViewController = SFSafariViewController(url: url as URL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    @objc func commentTap(sender:UIButton){
        postNum = sender.tag
        performSegue(withIdentifier: "GoPost", sender: nil)
    }
    
    @objc func likeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(contents[sender.tag].docID).collection("good").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = MyLikes()
                    likes.documentID = self.contents[sender.tag].docID
                    try! self.realm.write() {
                        self.realm.add(likes)
                        //セルのもう片方が選択されている場合の条件追加
                        if self.badArray.index(of: self.contents[sender.tag].docID) != nil{
                            self.db.collection("SNS").document(self.contents[sender.tag].docID).collection("bad").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.contents[sender.tag].docID)
                                    try! self.realm.write() {
                                        self.realm.delete(dislikes)
                                        if self.badArray.index(of: self.contents[sender.tag].docID) != nil{
                                            self.badArray.remove(at: self.badArray.index(of: self.contents[sender.tag].docID)!)
                                        }
                                        self.goodArray.append(self.contents[sender.tag].docID)
                                        self.contents[sender.tag].likeCount = self.contents[sender.tag].likeCount + 1
                                        self.contents[sender.tag].disLikeCount = self.contents[sender.tag].disLikeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.goodArray.append(self.contents[sender.tag].docID)
                            self.contents[sender.tag].likeCount = self.contents[sender.tag].likeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                        //                        self.mainTable.reloadRows(at: [row as IndexPath], with: .fade)
                    }
                    print("ドキュメント追加")
                }
            }
        }else{
            //dbから削除
            db.collection("SNS").document(contents[sender.tag].docID).collection("good").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.contents[sender.tag].docID)
                    try! self.realm.write() {
                        self.realm.delete(likes)
                        //                        if self.goodArray.index(of: self.contents[sender.tag].docID) != nil{
                        self.goodArray.remove(at: self.goodArray.index(of: self.contents[sender.tag].docID)!)
                        //                        }
                        self.contents[sender.tag].likeCount = self.contents[sender.tag].likeCount - 1
                        let row = NSIndexPath(row: sender.tag, section: 0)
                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                    }
                    print("ドキュメント削除")
                }
            }
        }
        print("Clicked \(sender.isSelected)")
        
    }
    @objc func dislikeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(contents[sender.tag].docID).collection("bad").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = MyDisLikes()
                    dislikes.documentID = self.contents[sender.tag].docID
                    
                    try! self.realm.write() {
                        self.realm.add(dislikes)
                        if self.goodArray.index(of: self.contents[sender.tag].docID) != nil{
                            self.db.collection("SNS").document(self.contents[sender.tag].docID).collection("good").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.contents[sender.tag].docID)
                                    try! self.realm.write() {
                                        self.realm.delete(likes)
                                        //                                        if self.goodArray.index(of: self.contents[sender.tag].docID) != nil{
                                        self.goodArray.remove(at: self.goodArray.index(of: self.contents[sender.tag].docID)!)
                                        //                                        }
                                        self.badArray.append(self.contents[sender.tag].docID)
                                        self.contents[sender.tag].disLikeCount = self.contents[sender.tag].disLikeCount + 1
                                        self.contents[sender.tag].likeCount = self.contents[sender.tag].likeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.badArray.append(self.contents[sender.tag].docID)
                            self.contents[sender.tag].disLikeCount = self.contents[sender.tag].disLikeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                    print("ドキュメント追加")
                }
            }
        }else{
            //dbから削除
            db.collection("SNS").document(contents[sender.tag].docID).collection("bad").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.contents[sender.tag].docID)
                    try! self.realm.write() {
                        self.realm.delete(dislikes)
                        if self.badArray.index(of: self.contents[sender.tag].docID) != nil{
                            self.badArray.remove(at: self.badArray.index(of: self.contents[sender.tag].docID)!)
                        }
                        self.contents[sender.tag].disLikeCount = self.contents[sender.tag].disLikeCount - 1
                        let row = NSIndexPath(row: sender.tag, section: 0)
                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                    }
                    print("ドキュメント削除")
                }
            }
        }
        print("Clicked \(sender.isSelected)")
    }
    
    
}
