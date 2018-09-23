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
import SafariServices
import PKHUD
import FirebaseStorageUI
class SearchListViewController: ViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    var resarchmiddleContents = [MiddleGetDtail]()
    var resarchContents = [GetDetail]()
    var num:Int!
    var postNum:Int!
    var goodArray = [String]()
    var badArray = [String]()
    let realm = try! Realm()
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var searchText: String!
    var backedNum: Int!
    var addFlag = true
    var pagingNum = 5
    var getnum = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        self.mainTable.register(UINib(nibName: "SNSTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        self.mainTable.register(UINib(nibName: "SNSwithUrlTableViewCell", bundle: nil), forCellReuseIdentifier: "SNSwithUrlTableViewCell")
        getData(text: searchText)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if backedNum != nil{
            let row = NSIndexPath(row: backedNum, section: 0)
            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
            backedNum = nil
        }
    }
    
    
    func getData(text:String){
        resarchmiddleContents = [MiddleGetDtail]()
        resarchContents = [GetDetail]()
        HUD.show(.progress)
        db.collection("SNS").whereField("tags.\(text)", isGreaterThan: 0).order(by: "tags.\(text)", descending: true).getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                if snap?.count == 0{
//                    searchBar.text = nil
                    self.view.endEditing(true)
                    HUD.hide()
                    self.alert(message: "何もないです")
                }else{
                    var num = 0
                    for doc in snap!.documents{
                        let data = doc.data()
                        self.resarchmiddleContents.append(MiddleGetDtail(num: num, title: data["title"] as! String, contents: data["content"] as! String, tagArray: data["tags"] as! [String : Int64], uid: data["uid"] as! String, username: data["name"] as! String, docID: doc.documentID, url: data["url"] as! String, date: data["date"] as! NSDate))
                        num += 1
                    }
                    for content in self.resarchmiddleContents{
                        self.db.collection("SNS").document(content.docID).collection("good").getDocuments(completion: { (snap, error) in
                            if let error = error {
                                self.alert(message: error.localizedDescription)
                            }else{
                                let likesNum = snap?.count
                                self.db.collection("SNS").document(content.docID).collection("bad").getDocuments(completion: { (snap, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                    }else{
                                        let disLikeNum = snap?.count
                                        self.db.collection("SNS").document(content.docID).collection("response").getDocuments(completion: { (snap, error) in
                                            if let error = error {
                                                self.alert(message: error.localizedDescription)
                                            }else{
                                                let commentNum = snap?.count
                                                self.resarchContents.append(GetDetail(num: content.num, title: content.title, contents: content.contents, tagArray: content.tagArray, uid: content.uid, username: content.username, docID: content.docID, url: content.url, likeCount: likesNum!, disLikeCount: disLikeNum!, commentCount: commentNum!, date: content.date))
                                            }
                                            if self.resarchContents.count == self.resarchmiddleContents.count{
                                                print(self.resarchContents)
                                                self.resarchContents.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                self.mainTable.reloadData()
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
    override func viewWillDisappear(_ animated: Bool) {
        //         resarchContents = [GetDetail]()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resarchContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch resarchContents[indexPath.row].url {
        case "":
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! SNSTableViewCell
            cell.tag = indexPath.row
            let reference = storageRef.child("image/profile/\(self.resarchContents[indexPath.row].uid!).jpg")
            cell.userImage.layer.cornerRadius = 25
            cell.userImage.layer.masksToBounds = true
            cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
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
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SNSwithUrlTableViewCell", for: indexPath) as! SNSwithUrlTableViewCell
            cell.tag = indexPath.row
            let reference = storageRef.child("image/profile/\(self.resarchContents[indexPath.row].uid!).jpg")
            cell.userImage.layer.cornerRadius = 25
            cell.userImage.layer.masksToBounds = true
            cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
            cell.nameLabel.text = resarchContents[indexPath.row].username
            cell.titleLabel.text = resarchContents[indexPath.row].title
            cell.contentLabel.text = resarchContents[indexPath.row].contents
            var param2 = WCLShineParams()
            param2.bigShineColor = UIColor(rgb: (255, 195, 55))
            cell.likeBtn.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
            cell.likeBtn.params = param2
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
            if self.goodArray.index(of:resarchContents[indexPath.row].docID ) != nil{
                cell.likeBtn.isSelected = true
            }else{
                cell.likeBtn.isSelected = false
            }
            var param3 = WCLShineParams()
            param3.bigShineColor = UIColor(rgb: (18, 255, 255))
            cell.disLikeBtn.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
            cell.disLikeBtn.params = param3
            cell.disLikeBtn.tag = indexPath.row
            cell.disLikeBtn.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
            if self.badArray.index(of: resarchContents[indexPath.row].docID) != nil{
                cell.disLikeBtn.isSelected = true
            }else{
                cell.disLikeBtn.isSelected = false
            }
            cell.commentBtn.imageView?.image = UIImage(named: "comment1")
            var keys = [String](resarchContents[indexPath.row].tagArray.keys)
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
            cell.commnetCount.text = "\(resarchContents[indexPath.row].commentCount!) comments"
            cell.likeCount.text = "\(resarchContents[indexPath.row].likeCount!) good"
            cell.disLikeCount.text = "\(resarchContents[indexPath.row].disLikeCount!) bad"
            cell.commentBtn.tag = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(self.commentTap(sender:)), for: .touchUpInside)
            cell.commnetCount.text = "\(resarchContents[indexPath.row].commentCount!) comments"
            cell.likeCount.text = "\(resarchContents[indexPath.row].likeCount!) good"
            cell.disLikeCount.text = "\(resarchContents[indexPath.row].disLikeCount!) bad"
            cell.urlLabel.text = resarchContents[indexPath.row].url
            cell.urlBtn.tag = indexPath.row
            cell.urlBtn.addTarget(self, action: #selector(self.urlTap(sender:)), for: .touchUpInside)
            return cell
        }
        
    }
    @objc func urlTap(sender:UIButton){
        if let url = NSURL(string: resarchContents[sender.tag].url) {
            let safariViewController = SFSafariViewController(url: url as URL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    @objc func commentTap(sender:UIButton){
        postNum = sender.tag
        performSegue(withIdentifier: "SearchPost", sender: nil)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        performSegue(withIdentifier: "SearchResultDetail", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchResultDetail"{
            let searchDetailViewController = segue.destination as! SearchDetailViewController
            searchDetailViewController.content = self.resarchContents[num]
            searchDetailViewController.presentNum = num
        }else if segue.identifier == "SearchPost"{
            let searchPostViewController = segue.destination as! SearchPostViewController
            searchPostViewController.resarchContent = self.resarchContents[postNum]
        }
    }
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if indexPath.row == resarchContents.count - 1 && mainTable.isDragging && addFlag == true{
//            print("一番下")
//            print(mainTable.isDragging)
//            addFlag = false
//            HUD.show(.progress)
//            let first = db.collection("SNS").whereField("tags.\(searchText)", isGreaterThan: 0).order(by: "tags.\(searchText)", descending: true).limit(to: pagingNum)
//            first.addSnapshotListener { (snapshot, error) in
//                guard let snapshot = snapshot else {
//                    print("Error retreving cities: \(error.debugDescription)")
//                    return
//                }
//                guard let lastSnapshot = snapshot.documents.last else {
//                    // The collection is empty.
//                    return
//                }
//                guard self.getnum == 0 && self.mainTable.isDragging  else{
//                    return
//                }
//                self.getnum += 1
//                let next = self.db.collection("SNS").whereField("tags.\(self.searchText)", isGreaterThan: 0).order(by: "tags.\(self.searchText)", descending: true).start(afterDocument: lastSnapshot).limit(to: 5)
//                next.getDocuments(completion: { (snap, error) in
//                    if let error = error {
//                        self.alert(message: error.localizedDescription)
//                    }else{
//                        let count = snap!.count
//                        var num = 0
//                        guard count != 0 else{
//                            HUD.hide()
//                            return
//                        }
//                        for doc in snap!.documents{
//                            let data = doc.data()
//
//                            self.db.collection("SNS").document(doc.documentID).collection("good").getDocuments(completion: { (snap, error) in
//                                if let error = error{
//                                    self.alert(message: error.localizedDescription)
//                                }else{
//                                    let goodCount = snap?.count
//                                    self.db.collection("SNS").document(doc.documentID).collection("bad").getDocuments(completion: { (snap, error) in
//                                        if let error = error{
//                                            self.alert(message: error.localizedDescription)
//                                        }else{
//                                            let badCount = snap?.count
//
//                                            print("getnum\(self.getnum)")
//                                            self.db.collection("SNS").document(doc.documentID).collection("response").getDocuments(completion: { (snap, error) in
//                                                if let error = error{
//                                                    self.alert(message: error.localizedDescription)
//                                                }else{
//                                                    let responseCount = snap?.count
//                                                    self.resarchContents.append(GetDetail(num: 1, title: data["title"] as! String, contents: data["content"] as! String, tagArray: data["tags"] as! [String : Int64], uid: data["uid"] as! String, username: data["name"] as! String, docID: doc.documentID, url: data["url"] as! String, likeCount: goodCount!, disLikeCount: badCount!, commentCount: responseCount!, date: data["date"] as! NSDate))
//                                                    num += 1
//                                                }
//                                                if num == count{
//                                                    self.resarchContents.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
//                                                    self.mainTable.reloadData()
//                                                    self.addFlag = true
//                                                    self.pagingNum = self.pagingNum + 5
//                                                    self.getnum = 0
//                                                    HUD.hide()
//                                                }
//                                            })
//                                        }
//                                    })
//                                }
//                            })
//                        }
//                    }
//                })
//            }
//        }
//
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
