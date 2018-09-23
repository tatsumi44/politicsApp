//
//  SNSListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/16.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import WCLShineButton
import RealmSwift
import PKHUD
import SafariServices
import FirebaseStorageUI
class SNSListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let db = Firestore.firestore()
    let realm = try! Realm()
    let storageRef = Storage.storage().reference()
    var middleContents = [MiddleGetDtail]()
    var contents = [GetDetail]()
    var resarchmiddleContents = [MiddleGetDtail]()
    var resarchContents = [GetDetail]()
    var num:Int!
    var postNum:Int!
    var goodArray = [String]()
    var badArray = [String]()
    var lastDate:NSDate!
    var addFlag = true
    var searchText: String!
//    var num1 = 7
    var num2 = 7
    var backedNum: Int!
    var postedContent: GetDetail!
    var getnum = 0
    override func viewDidLoad() {
        print("viewDidLoad()")
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        searchBar.delegate = self
        num = -1
        self.mainTable.register(UINib(nibName: "SNSTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell2")
        self.mainTable.register(UINib(nibName: "SNSwithUrlTableViewCell", bundle: nil), forCellReuseIdentifier: "SNSwithUrlTableViewCell")
        resarchmiddleContents = [MiddleGetDtail]()
        resarchContents = [GetDetail]()
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let likes = realm.objects(MyLikes.self)
        goodArray = [String]()
        badArray = [String]()
        likes.forEach { (like) in
            //                        try! realm.write() {
            //                            self.realm.delete(like)
            //                        }
            goodArray.append(like.documentID)
        }
        let dislikes = realm.objects(MyDisLikes.self)
        dislikes.forEach { (dislike) in
            //                        try! realm.write() {
            //                            self.realm.delete(dislike)
            //                        }
            badArray.append(dislike.documentID)
        }
        print("goodArray\(goodArray)")
        print("badArray\(badArray)")

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if backedNum != nil{
            print("cellnum: \(num)")
            print("commentCount: \(backedNum)")
            print("こっち")
//            contents[num].commentCount = backedNum
            let row = NSIndexPath(row: num, section: 0)
            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
            backedNum = nil
        }else{
            print("nilだよん")
        }
        print(postedContent)
        if postedContent != nil{
            contents.insert(postedContent, at: 0)
            print("これがね　\(contents.count)")
            num2 += 1
            print(contents.count)
            self.mainTable.reloadData()
            postedContent = nil
        }else{
            print("nilだよ")
        }
    }
    func getData() {
        HUD.show(.progress)
        db.collection("SNS").order(by: "date", descending: true).limit(to: 7).getDocuments { (snap, error) in
            self.contents = [GetDetail]()
            self.middleContents = [MiddleGetDtail]()
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                var num = 0
                for doc in snap!.documents{
                    let data = doc.data()
                    self.middleContents.append(MiddleGetDtail(num: num, title: data["title"] as! String, contents: data["content"] as! String, tagArray: data["tags"] as! [String : Int64], uid: data["uid"] as! String, username: data["name"] as! String, docID: doc.documentID, url: data["url"] as! String, date: data["date"] as! NSDate))
                    num += 1
                }
                
                for i in 0..<self.middleContents.count{
                    print(self.middleContents[i].title)
                    self.db.collection("SNS").document(self.middleContents[i].docID).collection("good").getDocuments(completion: { (snap, error) in
                        if let error = error {
                            self.alert(message: error.localizedDescription)
                        }else{
                            let likesNum = snap?.count
                            print("2\(self.middleContents[i].title)")
                            self.db.collection("SNS").document(self.middleContents[i].docID).collection("bad").getDocuments(completion: { (snap, error) in
                                //                                var num = 0
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let disLikeNum = snap?.count
                                    print("3\(self.middleContents[i].title)")
                                    self.db.collection("SNS").document(self.middleContents[i].docID).collection("response").getDocuments(completion: { (snap, error) in
                                        
                                        if let error = error {
                                            self.alert(message: error.localizedDescription)
                                        }else{
                                            let commentNum = snap?.count
                                            print("4\(self.middleContents[i].title)")
                                            self.contents.append(UIViewController.GetDetail(num: self.middleContents[i].num, title: self.middleContents[i].title, contents: self.middleContents[i].contents, tagArray:self.middleContents[i].tagArray, uid: self.middleContents[i].uid, username: self.middleContents[i].username, docID: self.middleContents[i].docID, url: self.middleContents[i].url, likeCount: likesNum!, disLikeCount: disLikeNum!, commentCount: commentNum!, date: self.middleContents[i].date))
                                            //                                            num += 1
                                        }
                                        if self.contents.count == self.middleContents.count{
                                            print("apple")
                                            self.contents.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                            self.lastDate = (self.contents.last?.date)!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        performSegue(withIdentifier: "Go", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go"{
            let commentTableViewController = segue.destination as! CommentDetailViewController
            commentTableViewController.content = self.contents[num]
            commentTableViewController.presentNum = self.num
        }else if segue.identifier == "Search"{
            let responseTableViewController = segue.destination as! SearchListViewController
            responseTableViewController.searchText = self.searchText
        }else if segue.identifier == "GoPost"{
            let snsPostViewController = segue.destination as! SNSPostViewController
            snsPostViewController.content = self.contents[postNum]
        }
        
    }
//    ページングの処理
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(contents.count)
        print(mainTable.isDragging)

        if indexPath.row == contents.count - 1 && mainTable.isDragging && addFlag == true{
            addFlag = false
            print(lastDate)
            print("一番下")
            HUD.show(.progress)
                let first = db.collection("SNS").order(by: "date", descending: true).limit(to: num2)
                first.addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        print("Error retreving cities: \(error.debugDescription)")
                        return
                    }
                    
                    guard let lastSnapshot = snapshot.documents.last else {
                        // The collection is empty.
                        return
                    }
                    
                    guard self.getnum == 0 && self.mainTable.isDragging  else{
                        return
                    }
                    self.getnum += 1
                    
                    let next = self.db.collection("SNS").order(by: "date", descending: true)
                        .start(afterDocument: lastSnapshot).limit(to: 7)
                    next.getDocuments(completion: { (snap, error) in
                        if let error = error {
                            self.alert(message: error.localizedDescription)
                        }else{
//                            print(snap?.count)
//                            self.addFlag = true
                            let count = snap!.count
                            var num = 0
                            if count != 0{
                                for doc in snap!.documents{
                                    let data = doc.data()

                                        self.db.collection("SNS").document(doc.documentID).collection("good").getDocuments(completion: { (snap, error) in
                                            if let error = error{
                                                self.alert(message: error.localizedDescription)
                                            }else{
                                                let goodCount = snap?.count
                                                self.db.collection("SNS").document(doc.documentID).collection("bad").getDocuments(completion: { (snap, error) in
                                                    if let error = error{
                                                        self.alert(message: error.localizedDescription)
                                                    }else{
                                                        let badCount = snap?.count
                                                        
                                                        print("getnum\(self.getnum)")
                                                        self.db.collection("SNS").document(doc.documentID).collection("response").getDocuments(completion: { (snap, error) in
                                                            if let error = error{
                                                                self.alert(message: error.localizedDescription)
                                                            }else{
                                                                let responseCount = snap?.count
                                                                self.contents.append(GetDetail(num: 1, title: data["title"] as! String, contents: data["content"] as! String, tagArray: data["tags"] as! [String : Int64], uid: data["uid"] as! String, username: data["name"] as! String, docID: doc.documentID, url: data["url"] as! String, likeCount: goodCount!, disLikeCount: badCount!, commentCount: responseCount!, date: data["date"] as! NSDate))
                                                                num += 1
                                                            }
                                                            if num == count{
                                                                self.contents.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                                self.mainTable.reloadData()
                                                                self.addFlag = true
                                                                self.num2 = self.num2 + 7
                                                                self.getnum = 0
                                                                HUD.hide()
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                }
                            }else{
                                HUD.hide()
                            }
                        }
                    })

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SNSListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            searchText = text
            searchBar.text = nil
            self.view.endEditing(true)
            self.performSegue(withIdentifier: "Search", sender: nil)
            
        }else{
            alert(message: "何か入力してください")
        }
    }
}
