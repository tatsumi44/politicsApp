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
import FirebaseStorageUI
class CommentDetailViewController: UIViewController,UITextViewDelegate {
    let SCREEN_SIZE = UIScreen.main.bounds.size
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var mainTable: UITableView!
    var content: GetDetail!
    var keysArray = [String]()
    let db = Firestore.firestore()
    let realm = try! Realm()
    let storageRef = Storage.storage().reference()
    var responseArray = [GetResponse]()
    var alertArray = [GetResponse]()
    var goodArray = [String]()
    var badArray = [String]()
    var flag = false
    var charaNum:Int!
    var postName:String!
    var commnetNum:Int!
    var alertNum :Int!
    var foldingFlg1 = false
    var foldingFlg2 = false
    let titleArray = ["","不適切な投稿"]
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
                    self.db.collection("SNS").document(self.content.docID).collection("response").document(doc.documentID).collection("alert").getDocuments(completion: { (snap1, error) in
                        if let error = error {
                            self.alert(message: error.localizedDescription)
                        }else{
                            let alertCount = snap1?.count
                            if alertCount == 0{
                                if data["opponentName"] as? String != nil{
                                    print("返信の返信")
                                    
                                    self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, alertNum: alertCount!, date: data["date"] as! NSDate))
                                }else{
                                    self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", alertNum: alertCount!, date: data["date"] as! NSDate))
                                }
                            }else{
                                if data["opponentName"] as? String != nil{
                                    print("返信の返信")
                                    
                                    self.alertArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, alertNum: alertCount!, date: data["date"] as! NSDate))
                                }else{
                                    self.alertArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", alertNum: alertCount!, date: data["date"] as! NSDate))
                                }
                            }

                            if (self.responseArray.count + self.alertArray.count) == snap?.count{
                                print(self.responseArray)
                                print(self.responseArray.count)
                                self.responseArray.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                self.alertArray.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                self.mainTable.reloadData()
                            }
                        }
                    })
                }
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
                            self.alertArray = [GetResponse]()
                            for doc in snap!.documents{
                                let data = doc.data()
                                self.db.collection("SNS").document(self.content.docID).collection("response").document(doc.documentID).collection("alert").getDocuments(completion: { (snap1, error) in
                                    if let error = error{
                                        self.alert(message: error.localizedDescription)
                                    }else{
                                        let alertCount = snap1?.count
                                        if alertCount != 0{
                                            if data["opponentName"] as? String != nil{
                                                print("返信の返信")
                                                self.alertArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, alertNum: alertCount!, date: data["date"] as! NSDate))
                                            }else{
                                                self.alertArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", alertNum: alertCount!, date: data["date"] as! NSDate))
                                            }
                                            if self.responseArray.count == snap?.count{
                                                self.responseArray.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                self.mainTable.reloadData()
                                            }
                                            
                                        }else{
                                            if data["opponentName"] as? String != nil{
                                                print("返信の返信")
                                                self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: data["opponentName"] as! String, opponentUid: data["opponentUid"] as! String, opponentDocID: data["opponentDocID"] as! String, alertNum: alertCount!, date: data["date"] as! NSDate))
                                            }else{
                                                self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["name"] as! String, opponentName: "", opponentUid: "", opponentDocID: "", alertNum: alertCount!, date: data["date"] as! NSDate))
                                            }
                                            if (self.responseArray.count + self.alertArray.count) == snap?.count{
                                                self.responseArray.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                self.alertArray.sort(by: {$0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970})
                                                self.mainTable.reloadData()
                                            }

                                        }
                                    }
                                })
                            }
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
        let response = realm.objects(SNSResponse.self)
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
                    ]){error in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            print("成功")
                            if response.count != 0{
                                if response.filter("snsID == %@",self.content.docID).count != 0{
                                   let response1 = response.filter("snsID == %@",self.content.docID)[0]
                                    try! self.realm.write() {
                                        response1.snsID = self.content.docID
                                        response1.snsDate = Date()
                                    }
                                    
                                }else{
                                    let response = SNSResponse()
                                    response.snsID = self.content.docID
                                    response.snsDate = Date()
                                    try! self.realm.write() {
                                        self.realm.add(response)
                                    }
                                }
                            }else{
                                let response = SNSResponse()
                                response.snsID = self.content.docID
                                response.snsDate = Date()
                                try! self.realm.write() {
                                    self.realm.add(response)
                                }
                            }
                            self.postTextView.text = nil
                            self.view.endEditing(true)
                        }
                    }
                }
            }else{
                db.collection("SNS").document(content.docID).collection("response").addDocument(data: [
                    "comment" : post,
                    "uid": user[0].userID,
                    "name": user[0].name,
                    "date": date
                ]){error in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        print("成功")
                        if response.count != 0{
                            if response.filter("snsID == %@",self.content.docID).count != 0{
                                let response1 = response.filter("snsID == %@",self.content.docID)[0]
                                try! self.realm.write() {
                                    response1.snsID = self.content.docID
                                    response1.snsDate = Date()
                                }
                                
                            }else{
                                let response = SNSResponse()
                                response.snsID = self.content.docID
                                response.snsDate = Date()
                                try! self.realm.write() {
                                    self.realm.add(response)
                                }
                            }
                        }else{
                            let response = SNSResponse()
                            response.snsID = self.content.docID
                            response.snsDate = Date()
                            try! self.realm.write() {
                                self.realm.add(response)
                            }
                        }
                        self.postTextView.text = nil
                        self.view.endEditing(true)
                    }
                }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return titleArray[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            // セクションのヘッダとなるビューを作成する。
            let myView: UIView = UIView()
            
            let label:UILabel = UILabel()
            label.text = "不適切な投稿"
            label.sizeToFit()
            label.textColor = UIColor.black
            
            myView.addSubview(label)
            myView.backgroundColor = UIColor(rgb: (r: 226, g: 226, b: 226))
            myView.alpha = 0.6
            // セクションのビューに対応する番号を設定する。
            myView.tag = section
            // セクションのビューにタップジェスチャーを設定する。
            myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(gestureRecognizer:))))
            
            return myView
        default:
            let myView: UIView = UIView()
            return  myView
        }
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        // タップされたセクションを取得する。
        guard let section = gestureRecognizer.view?.tag as Int? else {
            return
        }
        print(section)
        // フラグを設定する。
        switch section {
//        case 0:
//            foldingFlg1 = foldingFlg1 ? false : true
        case 1:
            if foldingFlg2 == false{
                foldingFlg2 = true
            }else{
                foldingFlg2 = false
            }
        default:
            break
        }
        // タップされたセクションを再読込する。
        mainTable.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
             return responseArray.count + 2
        default:
            switch foldingFlg2 {
            case false:
                return 0
            default:
                return alertArray.count
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 25
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                switch content.url{
                case "":
                    let cell = tableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! commentTableViewCell
                    let reference = storageRef.child("image/profile/\(self.content.uid!).jpg")
                    cell.userImage.layer.cornerRadius = 25
                    cell.userImage.layer.masksToBounds = true
                    cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
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
                    let reference = storageRef.child("image/profile/\(self.content.uid!).jpg")
                    cell.userImage.layer.cornerRadius = 25
                    cell.userImage.layer.masksToBounds = true
                    cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
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
                    let reference = storageRef.child("image/profile/\(self.responseArray[indexPath.row - 2].uid!).jpg")
                    cell.userImage.layer.cornerRadius = 20
                    cell.userImage.layer.masksToBounds = true
                    cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                    cell.nameLabel.text = "投稿者 \(responseArray[indexPath.row - 2].name!)"
                    cell.docidLabel.text = "投稿ID \(responseArray[indexPath.row - 2].docID!)"
                    cell.commentLabel.text = responseArray[indexPath.row - 2].comment
                    cell.dateLabel.text = stringFromDate(date: responseArray[indexPath.row - 2].date, format: "yyyy-MM-dd HH:mm:ss")
                    cell.commentBtn.tag = indexPath.row
                    cell.alertFlagBtn.tag = indexPath.row - 2
                    cell.commentBtn.addTarget(self, action: #selector(self.commnetTap(sender:)), for: .touchUpInside)
                    cell.alertFlagBtn.addTarget(self, action: #selector(self.alertTap(sender:)), for: .touchUpInside)
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "opposeTableViewCell", for: indexPath) as! opposeTableViewCell
                    let reference = storageRef.child("image/profile/\(self.responseArray[indexPath.row - 2].uid!).jpg")
                    cell.userImage.layer.cornerRadius = 20
                    cell.userImage.layer.masksToBounds = true
                    cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                    cell.nameLabel.text = responseArray[indexPath.row - 2].name
                    cell.commentLabel.text = responseArray[indexPath.row - 2].comment
                    cell.alertFlagBtn.tag = indexPath.row - 2
                    cell.alertFlagBtn.addTarget(self, action: #selector(self.alertTap(sender:)), for: .touchUpInside)
                    cell.dateLabel.text = stringFromDate(date: responseArray[indexPath.row - 2].date, format: "yyyy-MM-dd HH:mm:ss")
                    cell.opposeLabel.text = "<=  返信先 \(responseArray[indexPath.row - 2].opponentName!)＆返信先のID \(responseArray[indexPath.row - 2].opponentDocID!)"
                    cell.docIdLabel.text = "投稿ID \(responseArray[indexPath.row - 2].docID!)"
                    return cell
                }
            }
        default:
            switch alertArray[indexPath.row].opponentName {
            case "":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCell", for: indexPath) as! ResponseTableViewCell
                let reference = storageRef.child("image/profile/\(self.alertArray[indexPath.row].uid!).jpg")
                cell.userImage.layer.cornerRadius = 20
                cell.userImage.layer.masksToBounds = true
                cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                cell.nameLabel.text = "投稿者 \(alertArray[indexPath.row].name!)"
                cell.docidLabel.text = "投稿ID \(alertArray[indexPath.row].docID!)"
                cell.commentLabel.text = alertArray[indexPath.row].comment
                cell.dateLabel.text = stringFromDate(date: alertArray[indexPath.row].date, format: "yyyy-MM-dd HH:mm:ss")
                cell.commentBtn.tag = indexPath.row
                cell.alertFlagBtn.tag = indexPath.row - 2
                cell.commentBtn.addTarget(self, action: #selector(self.commnetTap(sender:)), for: .touchUpInside)
                cell.alertFlagBtn.addTarget(self, action: #selector(self.alertTap(sender:)), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "opposeTableViewCell", for: indexPath) as! opposeTableViewCell
                let reference = storageRef.child("image/profile/\(self.alertArray[indexPath.row].uid!).jpg")
                cell.userImage.layer.cornerRadius = 20
                cell.userImage.layer.masksToBounds = true
                cell.userImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                cell.nameLabel.text = alertArray[indexPath.row].name
                cell.commentLabel.text = alertArray[indexPath.row].comment
                cell.alertFlagBtn.tag = indexPath.row - 2
                cell.alertFlagBtn.addTarget(self, action: #selector(self.alertTap(sender:)), for: .touchUpInside)
                cell.dateLabel.text = stringFromDate(date: alertArray[indexPath.row].date, format: "yyyy-MM-dd HH:mm:ss")
                cell.opposeLabel.text = "<=  返信先 \(alertArray[indexPath.row].opponentName!)＆返信先のID \(alertArray[indexPath.row].opponentDocID!)"
                cell.docIdLabel.text = "投稿ID \(alertArray[indexPath.row].docID!)"
                return cell
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "alert"{
            let alertFlagViewController = segue.destination as! AlertFlagViewController
            alertFlagViewController.content = self.content
            alertFlagViewController.response = self.responseArray[alertNum]
        }
    }
    
    @objc func alertTap(sender:UIButton){
        alertNum = sender.tag
        performSegue(withIdentifier: "alert", sender: nil)
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
        cell.tagLabel.layer.cornerRadius = 4
        cell.tagLabel.layer.masksToBounds = true
        cell.tagLabel.text = keysArray[indexPath.row]
        return cell
        
    }
}
