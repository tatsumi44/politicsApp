//
//  CommentDetailViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/17.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import UserNotifications
import WCLShineButton
import Firebase
import RealmSwift
import SwiftDate
import SafariServices
class CommentDetailViewController: UIViewController,UITextViewDelegate {
    let SCREEN_SIZE = UIScreen.main.bounds.size
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var mainTable: UITableView!
    var content: GetDetail!
    var keysArray = [String]()
    let db = Firestore.firestore()
    let realm = try! Realm()
    var responseArray = [GetResponse]()
    var goodArray = [String]()
    var badArray = [String]()
    var flag = false
    var charaNum:Int!
    var postName:String!
    var commnetNum:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        postTextView.delegate = self
        postTextView.layer.borderColor = UIColor.black.cgColor
        postTextView.layer.borderWidth = 1
        let transform = CGAffineTransform(translationX: 0, y: -(postView.frame.height + 2))
        self.mainTable.transform = transform
        self.mainTable.register(UINib(nibName: "commentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentTableViewCell")
        self.mainTable.register(UINib(nibName: "TagTableViewCell", bundle: nil), forCellReuseIdentifier: "TagTableViewCell")
        self.mainTable.register(UINib(nibName: "ResponseTableViewCell", bundle: nil), forCellReuseIdentifier: "ResponseTableViewCell")
        self.mainTable.register(UINib(nibName: "commentWithUrlTableViewCell", bundle: nil), forCellReuseIdentifier: "commentWithUrlTableViewCell")
        self.mainTable.register(UINib(nibName: "opposeTableViewCell", bundle: nil), forCellReuseIdentifier: "opposeTableViewCell")
        let tags = content.tagArray
        keysArray = [String](tags!.keys)
        db.collection("SNS").document(content.docID).collection("response").order(by: "date", descending: true).getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                for doc in snap!.documents{
                    let data = doc.data()
                    if data["opponentName"] as? String != nil{
                        print("返信の返信")
                        self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, date: data["date"] as! NSDate))
                    }else{
                        self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", date: data["date"] as! NSDate))
                    }
                    
                }
                print(self.responseArray)
                print(self.responseArray.count)
                self.mainTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeybordWillHideNotification(_:)), name: .UIKeyboardWillHide, object: nil)
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
        
        db.collection("SNS").document(content.docID).collection("response").addSnapshotListener { (snap, error) in
            guard let val = snap else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            val.documentChanges.forEach({ (diff) in
                if diff.type == .modified{
                    print("イベント検知したよ")
                    self.db.collection("SNS").document(self.content.docID).collection("response").order(by: "date", descending: true).getDocuments { (snap, error) in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            self.responseArray = [GetResponse]()
                            for doc in snap!.documents{
                                let data = doc.data()
                                if data["opponentName"] as? String != nil{
                                    print("返信の返信")
                                    self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, date: data["date"] as! NSDate))
                                }else{
                                    self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", date: data["date"] as! NSDate))
                                }
                            }
                            print(self.responseArray)
                            self.mainTable.reloadData()
                            
                        }
                    }
                }
            })
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification){
        let tabheight = tabBarController?.tabBar.frame.size.height
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        UIView.animate(withDuration: duration, animations: {
            let transform = CGAffineTransform(translationX: 0, y: -(keyboardFrame.size.height + 2) + tabheight!)
            self.postView.transform = transform
        }, completion: nil)
    }
    
    @objc func handleKeybordWillHideNotification(_ notification: Notification){
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            let transform = CGAffineTransform (translationX: 0, y: 0)
            self.postView.transform = transform
            self.postTextView.layer.borderColor = UIColor.black.cgColor
            self.postTextView.layer.borderWidth = 0.5
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる処理
        view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        if text == "\n" {
            let maxHeight = 80.0  // 入力フィールドの最大サイズ
            if(textView.frame.size.height.native < maxHeight) {
                let size:CGSize = postTextView.sizeThatFits(postTextView.frame.size)
                postTextView.frame.size.height = size.height
                postTextView.frame.origin.y = postTextView.frame.origin.y - 16
            }
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func decide(_ sender: Any) {
        let user = realm.objects(Userdata.self)
        let date  = NSDate()
        if let post = postTextView.text{
            if post.prefix(1) == "@"{
                print("返信")
                print(post.prefix(charaNum))
                if postName != post.prefix(charaNum){
                    alert(message: "相手は正しく入力してください")
                    
                }else{
                    let num = post.count
                    print(post[post.index(post.startIndex, offsetBy: charaNum)..<post.index(post.startIndex, offsetBy: num)])
                    db.collection("SNS").document(content.docID).collection("response").addDocument(data: [
                        "comment" : "\(post[post.index(post.startIndex, offsetBy: charaNum)..<post.index(post.startIndex, offsetBy: num)])",
                        "uid": user[0].userID,
                        "name": user[0].name,
                        "opponentName": "\(postName!)",
                        "opponentUid":"\(responseArray[commnetNum - 2].uid!)",
                        "opponentDocID":"\(responseArray[commnetNum - 2].docID!)",
                        "date": date
                        ])
                    print("成功")
                    postTextView.text = nil
                    view.endEditing(true)
                }
            }else{
                db.collection("SNS").document(content.docID).collection("response").addDocument(data: [
                    "comment" : post,
                    "uid": user[0].userID,
                    "name": user[0].name,
                    "date": date
                    ])
                postTextView.text = nil
                view.endEditing(true)
            }
        }else{
            alert(message: "ちゃんと入力してや！")
        }
    }
}

extension CommentDetailViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let cell = cell as? TagTableViewCell else { return }
        
        //ShopTableViewCell.swiftで設定したメソッドを呼び出す
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            switch content.url{
            case "":
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! commentTableViewCell
                cell.nameLabel.text = content.username
                cell.title.text = content.title
                cell.content.text = content.contents
                var param2 = WCLShineParams()
                param2.bigShineColor = UIColor(rgb: (255, 195, 55))
                cell.btn1.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
                cell.btn1.params = param2
                cell.btn1.tag = indexPath.row
                if self.goodArray.index(of:content.docID) != nil{
                    cell.btn1.isSelected = true
                }else{
                    cell.btn1.isSelected = false
                }
                cell.btn1.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
                var param3 = WCLShineParams()
                param3.bigShineColor = UIColor(rgb: (18, 255, 255))
                cell.btn2.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
                cell.btn2.params = param3
                cell.btn2.tag = indexPath.row
                if self.badArray.index(of: content.docID) != nil{
                    cell.btn2.isSelected = true
                }else{
                    cell.btn2.isSelected = false
                }
                cell.btn2.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
                cell.likecount.text = "\(content.likeCount!) good"
                cell.dislikecount.text = "\(content.disLikeCount!) bad"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentWithUrlTableViewCell", for: indexPath) as! commentWithUrlTableViewCell
                cell.nameLabel.text = content.username
                cell.titleLabel.text = content.title
                cell.contentLabel.text = content.contents
                var param2 = WCLShineParams()
                param2.bigShineColor = UIColor(rgb: (255, 195, 55))
                cell.likeBtn.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
                cell.likeBtn.params = param2
                cell.likeBtn.tag = indexPath.row
                if self.goodArray.index(of:content.docID) != nil{
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
                if self.badArray.index(of: content.docID) != nil{
                    cell.disLikeBtn.isSelected = true
                }else{
                    cell.disLikeBtn.isSelected = false
                }
                cell.disLikeBtn.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
                cell.likeCount.text = "\(content.likeCount!) good"
                cell.disLikeCount.text = "\(content.disLikeCount!) bad"
                cell.urlLabel.text = content.url
                cell.urlBtn.tag = indexPath.row
                cell.urlBtn.addTarget(self, action: #selector(self.urlTap(sender:)), for: .touchUpInside)
                return cell
            }
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagTableViewCell", for: indexPath) as! TagTableViewCell
            let tagnum = content.tagArray.count
            let num = floor(Double(tagnum / 3))
            if num == 0 || tagnum == 3{
                cell.cellHeight.constant = 35
            }else{
                cell.cellHeight.constant = CGFloat(35 * (num + 1))
            }
            
            return cell
        default:
            switch responseArray[indexPath.row - 2].opponentName {
            case "":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCell", for: indexPath) as! ResponseTableViewCell
                cell.nameLabel.text = "投稿者 \(responseArray[indexPath.row - 2].name!)"
                cell.docidLabel.text = "投稿ID \(responseArray[indexPath.row - 2].docID!)"
                cell.commentLabel.text = responseArray[indexPath.row - 2].comment
                cell.dateLabel.text = stringFromDate(date: responseArray[indexPath.row - 2].date, format: "yyyy-MM-dd HH:mm:ss")
                cell.commentBtn.tag = indexPath.row
                cell.commentBtn.addTarget(self, action: #selector(self.commnetTap(sender:)), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "opposeTableViewCell", for: indexPath) as! opposeTableViewCell
                cell.nameLabel.text = responseArray[indexPath.row - 2].name
                cell.commentLabel.text = responseArray[indexPath.row - 2].comment
                cell.dateLabel.text = stringFromDate(date: responseArray[indexPath.row - 2].date, format: "yyyy-MM-dd HH:mm:ss")
                cell.opposeLabel.text = "<=  返信先 \(responseArray[indexPath.row - 2].opponentName!)＆返信先のID \(responseArray[indexPath.row - 2].opponentDocID!)"
                cell.docIdLabel.text = "投稿ID \(responseArray[indexPath.row - 2].docID!)"
                return cell
            }
        }
    }
    @objc func commnetTap(sender:UIButton){
        
        commnetNum = sender.tag
        postName = "@\(responseArray[commnetNum - 2].name!) "
        postTextView.text = postName
        charaNum = postTextView.text.count
        let text = NSMutableAttributedString(string: postName)
        text.addAttribute(.foregroundColor, value: UIColor.blue, range: NSMakeRange(0, charaNum - 1))
        postTextView.attributedText = text
        print(charaNum)
    }
    
    @objc func likeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(self.content.docID).collection("good").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = MyLikes()
                    likes.documentID = self.content.docID
                    try! self.realm.write() {
                        self.realm.add(likes)
                        //セルのもう片方が選択されている場合の条件追加
                        if self.badArray.index(of: self.content.docID) != nil{
                            self.db.collection("SNS").document(self.content.docID).collection("bad").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.content.docID)
                                    try! self.realm.write() {
                                        self.realm.delete(dislikes)
                                        if self.badArray.index(of: self.content.docID) != nil{
                                            self.badArray.remove(at: self.badArray.index(of: self.content.docID)!)
                                        }
                                        self.goodArray.append(self.content.docID)
                                        self.content.likeCount = self.content.likeCount + 1
                                        self.content.disLikeCount = self.content.disLikeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.goodArray.append(self.content.docID)
                            self.content.likeCount = self.content.likeCount + 1
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
            db.collection("SNS").document(content.docID).collection("good").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.content.docID)
                    try! self.realm.write() {
                        self.realm.delete(likes)
                        if self.goodArray.index(of: self.content.docID) != nil{
                            self.goodArray.remove(at: self.goodArray.index(of: self.content.docID)!)
                        }
                        self.content.likeCount = self.content.likeCount - 1
                        let row = NSIndexPath(row: sender.tag, section: 0)
                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                    }
                    print("ドキュメント削除")
                }
            }
        }
        print("Clicked \(sender.isSelected)")
    }
    
    @objc func urlTap(sender:UIButton){
        if let url = NSURL(string: content.url) {
            let safariViewController = SFSafariViewController(url: url as URL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc func dislikeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        if sender.isSelected == false{
            //dbに入れる
            db.collection("SNS").document(content.docID).collection("bad").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = MyDisLikes()
                    dislikes.documentID = self.content.docID
                    
                    try! self.realm.write() {
                        self.realm.add(dislikes)
                        if self.goodArray.index(of: self.content.docID) != nil{
                            self.db.collection("SNS").document(self.content.docID).collection("good").document(user[0].userID).delete(){error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let likes = self.realm.objects(MyLikes.self).filter("documentID == %@",self.content.docID)
                                    try! self.realm.write() {
                                        self.realm.delete(likes)
                                        if self.goodArray.index(of: self.content.docID) != nil{
                                            self.goodArray.remove(at: self.goodArray.index(of: self.content.docID)!)
                                        }
                                        self.badArray.append(self.content.docID)
                                        self.content.disLikeCount = self.content.disLikeCount + 1
                                        self.content.likeCount = self.content.likeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.badArray.append(self.content.docID)
                            self.content.disLikeCount = self.content.disLikeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                    print("ドキュメント追加")
                }
            }
        }else{
            //dbから削除
            db.collection("SNS").document(content.docID).collection("bad").document(user[0].userID).delete(){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = self.realm.objects(MyDisLikes.self).filter("documentID == %@",self.content.docID)
                    try! self.realm.write() {
                        self.realm.delete(dislikes)
                        if self.badArray.index(of: self.content.docID) != nil{
                            self.badArray.remove(at: self.badArray.index(of: self.content.docID)!)
                        }
                        self.content.disLikeCount = self.content.disLikeCount - 1
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


extension CommentDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.tagArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.tagLabel.text = keysArray[indexPath.row]
        return cell
        
    }
}
