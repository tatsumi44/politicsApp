//
//  NewsDetailViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/25.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import WCLShineButton
import SafariServices
class NewsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    var mainNews:MainNewsData!
    var date:String!
    var responseArray = [GetResponse]()
    var goodArray = [String]()
    var badArray = [String]()
//    let comviewPosy = self.commentView.frame.origin.y
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate = self
        commentTextView.layer.borderColor = UIColor.black.cgColor
        commentTextView.layer.borderWidth = 0.5
        let transform = CGAffineTransform(translationX: 0, y: -(commentView.frame.height + 2))
        self.mainTable.transform = transform
        self.mainTable.register(UINib(nibName: "NewsTodayTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTodayTableViewCell")
        self.mainTable.register(UINib(nibName: "ResponseTableViewCell", bundle: nil), forCellReuseIdentifier: "ResponseTableViewCell")
        db.collection("news").document(date).collection(newsurlPath(newsURL: mainNews.url)).order(by: "date", descending: true).getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                for doc in snap!.documents{
                    let data = doc.data()
                    self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["username"] as! String, date: data["date"] as! NSDate))
                }
                print(self.responseArray)
                self.mainTable.reloadData()
            }
        }


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardWillShowNotification(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeybordWillHideNotification(_:)), name: .UIKeyboardWillHide, object: nil)
        let likes = realm.objects(NewsLikes.self)
        goodArray = [String]()
        badArray = [String]()
        likes.forEach { (like) in
            goodArray.append(like.documentID)
        }
        let dislikes = realm.objects(NewsDisLikes.self)
        dislikes.forEach { (dislike) in
            badArray.append(dislike.documentID)
        }
        db.collection("news").document(date).collection(newsurlPath(newsURL:mainNews.url)).addSnapshotListener { (snap, error) in
            guard let val = snap else {
                print("Error fetching documents: \(error!)")
                return
            }
            val.documentChanges.forEach({ (diff) in
                if diff.type == .modified{
                    print("イベント検知")
                    self.db.collection("news").document(self.date).collection(self.newsurlPath(newsURL: self.mainNews.url)).order(by: "date", descending: true).getDocuments(completion: { (snap, error) in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            self.responseArray = [GetResponse]()
                            for doc in snap!.documents{
                                let data = doc.data()
                                self.responseArray.append(GetResponse(docID: doc.documentID, comment: data["comment"] as! String, uid: data["uid"] as! String, name: data["username"] as! String, date: data["date"] as! NSDate))
                            }
                            self.mainTable.reloadData()
                        }
                    })
                    
                }
            })
        }
        
    }
    
    @IBAction func decide(_ sender: Any) {
        let user = self.realm.objects(Userdata.self)
        db.collection("news").document(date).collection(newsurlPath(newsURL: mainNews.url)).addDocument(data: [
            "comment" : commentTextView.text,
            "date": NSDate(),
            "title": self.mainNews.title,
            "url": self.mainNews.url,
            "uid": user[0].userID,
            "username":user[0].name,
            "userImagePath": "/"
            ])
        commentTextView.text = nil
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
            self.commentView.transform = transform
        }, completion: nil)
    }
    
    @objc func handleKeybordWillHideNotification(_ notification: Notification){
        let height = UIScreen.main.bounds.size.height
        let tabheight = tabBarController?.tabBar.frame.size.height
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            let transform = CGAffineTransform (translationX: 0, y: 0)
            self.commentView.transform = transform
            self.commentView.frame.size.height = 30
            self.commentView.frame.origin.x = 0
            self.commentView.frame.origin.y = height - tabheight! - 32
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseArray.count + 1
  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTodayTableViewCell", for: indexPath) as! NewsTodayTableViewCell
            cell.titleLabel.text = mainNews.title
            cell.dateLabel.text = mainNews.date
            cell.titleBtn.tag = indexPath.row
            cell.titleBtn.addTarget(self, action: #selector(self.titleTap(sender:)), for: .touchUpInside)
            var param2 = WCLShineParams()
            param2.bigShineColor = UIColor(rgb: (255, 195, 55))
            cell.likeLabel.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
            cell.likeLabel.params = param2
            cell.likeLabel.tag = indexPath.row
            if self.goodArray.index(of: newsurlPath(newsURL: mainNews.url)) != nil{
                cell.likeLabel.isSelected = true
            }else{
                cell.likeLabel.isSelected = false
            }
            cell.likeLabel.addTarget(self, action: #selector(self.likeTap(sender:)), for: .touchUpInside)
            var param3 = WCLShineParams()
            param3.bigShineColor = UIColor(rgb: (18, 255, 255))
            cell.disLikeLabel.image = .defaultAndSelect(#imageLiteral(resourceName: "bud"), #imageLiteral(resourceName: "bud_before"))
            cell.disLikeLabel.params = param3
            cell.disLikeLabel.tag = indexPath.row
            if self.badArray.index(of: newsurlPath(newsURL: mainNews.url)) != nil{
                cell.disLikeLabel.isSelected = true
            }else{
                cell.disLikeLabel.isSelected = false
            }
            cell.disLikeLabel.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
            cell.likeCount.text = "\(mainNews.likeCount!) good"
            cell.disLikeCount.text = "\(mainNews.disLikeCount!) bad"
            cell.commentCount.text = "\(mainNews.commentCount!) comment"
            return cell

        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCell", for: indexPath) as! ResponseTableViewCell
             cell.commentLabel.text = responseArray[indexPath.row - 1].comment
             cell.nameLabel.text = responseArray[indexPath.row - 1].name
             cell.dateLabel.text = stringFromDate(date: responseArray[indexPath.row - 1].date, format: "yyyy年MM月dd日 HH時mm分ss秒")
            return cell
        }
    }
    
    @objc func likeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        let urlString = newsurlPath(newsURL: mainNews.url)
        if sender.isSelected == false{
            db.collection("news").document(date).collection(urlString).document("evaluate").collection("good").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = NewsLikes()
                    likes.documentID = urlString
                    try! self.realm.write() {
                        self.realm.add(likes)
                        if self.badArray.index(of: urlString) != nil{
                            self.db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("bad").document(user[0].userID).delete(){
                                error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let dislikes = self.realm.objects(NewsDisLikes.self).filter("documentID == %@",urlString)
                                    try! self.realm.write() {
                                        self.realm.delete(dislikes)
                                        self.badArray.remove(at: self.badArray.index(of: urlString)!)
                                        self.goodArray.append(urlString)
                                        self.mainNews.likeCount = self.mainNews.likeCount + 1
                                        self.mainNews.disLikeCount = self.mainNews.disLikeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.goodArray.append(urlString)
                            self.mainNews.likeCount = self.mainNews.likeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                }
                print("ドキュメント追加")
            }
        }else{
            db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("good").document(user[0].userID).delete(){
                error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    if self.goodArray.index(of: urlString) != nil{
                        let likes = self.realm.objects(NewsLikes.self).filter("documentID == %@",urlString)
                        try! self.realm.write() {
                            self.realm.delete(likes)
                            self.goodArray.remove(at: self.goodArray.index(of: urlString)!)
                            self.mainNews.likeCount = self.mainNews.likeCount - 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                        print("ドキュメント削除")
                    }
                }
            }
        }
        print("Clicked \(sender.isSelected)")
    }
    
    @objc func dislikeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        let urlString = newsurlPath(newsURL: mainNews.url)
        if sender.isSelected == false{
            db.collection("news").document(date).collection(urlString).document("evaluate").collection("bad").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = NewsDisLikes()
                    dislikes.documentID = urlString
                    try! self.realm.write() {
                        self.realm.add(dislikes)
                        if self.goodArray.index(of: urlString) != nil{
                            self.db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("good").document(user[0].userID).delete(){
                                error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let likes = self.realm.objects(NewsLikes.self).filter("documentID == %@",urlString)
                                    try! self.realm.write() {
                                        self.realm.delete(likes)
                                        self.goodArray.remove(at: self.goodArray.index(of: urlString)!)
                                        self.badArray.append(urlString)
                                        self.mainNews.disLikeCount = self.mainNews.disLikeCount + 1
                                        self.mainNews.likeCount = self.mainNews.likeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.badArray.append(urlString)
                            self.mainNews.disLikeCount = self.mainNews.disLikeCount + 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                    }
                }
                print("ドキュメント追加")
            }
        }else{
            db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("bad").document(user[0].userID).delete(){
                error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    if self.badArray.index(of: urlString) != nil{
                        let dislikes = self.realm.objects(NewsDisLikes.self).filter("documentID == %@",urlString)
                        try! self.realm.write() {
                            self.realm.delete(dislikes)
                            self.badArray.remove(at: self.badArray.index(of: urlString)!)
                            self.mainNews.disLikeCount = self.mainNews.disLikeCount - 1
                            let row = NSIndexPath(row: sender.tag, section: 0)
                            self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                        }
                        print("ドキュメント削除")
                    }
                }
            }
        }
        print("Clicked \(sender.isSelected)")
    }
    
    
    @objc func titleTap(sender:UIButton){
//        var strUrl : String = mainNews.url
        if let url = NSURL(string: mainNews.url) {
            let safariViewController = SFSafariViewController(url: url as URL)
            present(safariViewController, animated: true, completion: nil)
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "GoNews"{
//            let newsViewController = segue.destination as! NewsViewController
//            newsViewController.url = mainNews.url
//        }
    }
    
}
