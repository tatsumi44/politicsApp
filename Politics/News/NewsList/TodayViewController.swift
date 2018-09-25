//
//  TodayViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/24.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import WCLShineButton
import PKHUD
import SafariServices
class TodayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mainTable: UITableView!
//    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    let realm = try! Realm()
    var newsArray = [NewsData]()
    var mainNewsArray = [MainNewsData]()
    var num:Int!
    var comnum:Int!
    var detailnum:Int!
    var navBarHeight:CGFloat!
    var tabheight:CGFloat!
    var date:String!
    var goodArray = [String]()
    var badArray = [String]()
    var backedNum:Int!
    var dateNum:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        self.mainTable.register(UINib(nibName: "NewsTodayTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTodayTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let likes = realm.objects(NewsLikes1.self)
        goodArray = [String]()
        badArray = [String]()
        likes.forEach { (like) in
            goodArray.append(like.documentID)
        }
        let dislikes = realm.objects(NewsDisLikes1.self)
        dislikes.forEach { (dislike) in
            badArray.append(dislike.documentID)
        }
        print("goodArray\(goodArray)")
        print("badArray\(badArray)")
    }
    
    func getNews(date:String){
        HUD.show(.progress)
        db.collection("news").document(date).getDocument { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                if self.newsArray.count != 0{
                    self.newsArray = [NewsData]()
                    self.mainNewsArray = [MainNewsData]()
                }
                var num = 0
                if let data = snap?.data(){
                    let jsons = data["json"] as! [[String : String]]
                    if jsons.count == 0{
                         HUD.hide()
                    }else{
                        for json in jsons{
                            let title = json["name"]
                            let url = json["url"]
                            let date = json["date"]
                            self.newsArray.append(NewsData(num: num, title: title!, url: url!, date: date!))
                            num += 1
                        }
                        print(self.newsArray)
                        for news in self.newsArray{
                            self.db.collection("news").document(self.date).collection(self.newsurlPath(newsURL: news.url)).getDocuments(completion: { (snap, error) in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let commnetCount = snap?.count
                                    self.db.collection("news").document(self.date).collection(self.newsurlPath(newsURL: news.url)).document("evaluate").collection("good").getDocuments(completion: { (snap, error) in
                                        if let error = error{
                                            self.alert(message: error.localizedDescription)
                                        }else{
                                            let likeCount = snap?.count
                                            self.db.collection("news").document(self.date).collection(self.newsurlPath(newsURL: news.url)).document("evaluate").collection("bad").getDocuments(completion: { (snap, error) in
                                                if let error = error{
                                                    self.alert(message: error.localizedDescription)
                                                }else{
                                                    let dislikeCount = snap?.count
                                                    self.mainNewsArray.append(MainNewsData(num: news.num, title: news.title, url: news.url, likeCount: likeCount!, disLikeCount: dislikeCount!, commentCount: commnetCount!, date: news.date))
                                                }
                                                if self.newsArray.count == self.mainNewsArray.count{
                                                    self.mainNewsArray.sort(by: {$0.num < $1.num})
                                                    self.mainTable.reloadData()
                                                    HUD.hide()
                                                    print("いいかもね")
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
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTodayTableViewCell", for: indexPath) as! NewsTodayTableViewCell
        cell.titleBtn.tag = indexPath.row
        cell.titleBtn.addTarget(self, action: #selector(self.titleTap(sender:)), for: .touchUpInside)
        cell.titleLabel.text = newsArray[indexPath.row].title
        cell.titleLabel.tag = indexPath.row
        cell.dateLabel.text = newsArray[indexPath.row].date
        cell.commentBtn.tag = indexPath.row
        cell.commentBtn.addTarget(self, action: #selector(self.commentTap(sender:)), for: .touchUpInside)
        var param2 = WCLShineParams()
        param2.bigShineColor = UIColor(rgb: (255, 195, 55))
        cell.likeLabel.image = .defaultAndSelect(#imageLiteral(resourceName: "Like_before"), #imageLiteral(resourceName: "LIke"))
        cell.likeLabel.params = param2
        cell.likeLabel.tag = indexPath.row
        if self.goodArray.index(of: newsurlPath(newsURL: mainNewsArray[indexPath.row].url)) != nil{
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
        if self.badArray.index(of: newsurlPath(newsURL: mainNewsArray[indexPath.row].url)) != nil{
            cell.disLikeLabel.isSelected = true
        }else{
            cell.disLikeLabel.isSelected = false
        }
        cell.disLikeLabel.addTarget(self, action: #selector(self.dislikeTap(sender:)), for: .touchUpInside)
        cell.commentCount.text = "\(mainNewsArray[indexPath.row].commentCount!) comment"
        cell.likeCount.text = "\(mainNewsArray[indexPath.row].likeCount!) good"
        cell.disLikeCount.text = "\(mainNewsArray[indexPath.row].disLikeCount!) bad"
        return cell
    }
    
    @objc func likeTap(sender:WCLShineButton){
        let user = realm.objects(Userdata.self)
        let urlString = newsurlPath(newsURL: newsArray[sender.tag].url)
        if sender.isSelected == false{
            db.collection("news").document(date).collection(urlString).document("evaluate").collection("good").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let likes = NewsLikes1()
                    likes.documentID = urlString
                    likes.date = self.newsArray[sender.tag].date
                    try! self.realm.write() {
                        self.realm.add(likes)
                        if self.badArray.index(of: urlString) != nil{
                            self.db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("bad").document(user[0].userID).delete(){
                                error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let dislikes = self.realm.objects(NewsDisLikes1.self).filter("documentID == %@",urlString)
                                    try! self.realm.write() {
                                        self.realm.delete(dislikes)
                                        self.badArray.remove(at: self.badArray.index(of: urlString)!)
                                        self.goodArray.append(urlString)
                                        self.mainNewsArray[sender.tag].likeCount = self.mainNewsArray[sender.tag].likeCount + 1
                                        self.mainNewsArray[sender.tag].disLikeCount = self.mainNewsArray[sender.tag].disLikeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.goodArray.append(urlString)
                            self.mainNewsArray[sender.tag].likeCount = self.mainNewsArray[sender.tag].likeCount + 1
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
                        let likes = self.realm.objects(NewsLikes1.self).filter("documentID == %@",urlString)
                        try! self.realm.write() {
                            self.realm.delete(likes)
                            self.goodArray.remove(at: self.goodArray.index(of: urlString)!)
                            self.mainNewsArray[sender.tag].likeCount = self.mainNewsArray[sender.tag].likeCount - 1
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
        let urlString = newsurlPath(newsURL: newsArray[sender.tag].url)
        if sender.isSelected == false{
            db.collection("news").document(date).collection(urlString).document("evaluate").collection("bad").document(user[0].userID).setData([
                "name" : user[0].name
            ]){error in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    let dislikes = NewsDisLikes1()
                    dislikes.documentID = urlString
                    dislikes.date = self.newsArray[sender.tag].date
                    try! self.realm.write() {
                        self.realm.add(dislikes)
                        if self.goodArray.index(of: urlString) != nil{
                            self.db.collection("news").document(self.date).collection(urlString).document("evaluate").collection("good").document(user[0].userID).delete(){
                                error in
                                if let error = error{
                                    self.alert(message: error.localizedDescription)
                                }else{
                                    let likes = self.realm.objects(NewsLikes1.self).filter("documentID == %@",urlString)
                                    try! self.realm.write() {
                                        self.realm.delete(likes)
                                        self.goodArray.remove(at: self.goodArray.index(of: urlString)!)
                                        self.badArray.append(urlString)
                                        self.mainNewsArray[sender.tag].disLikeCount = self.mainNewsArray[sender.tag].disLikeCount + 1
                                        self.mainNewsArray[sender.tag].likeCount = self.mainNewsArray[sender.tag].likeCount - 1
                                        let row = NSIndexPath(row: sender.tag, section: 0)
                                        self.mainTable.reloadRows(at: [row as IndexPath], with: .automatic)
                                    }
                                    print("ドキュメント削除")
                                }
                            }
                        }else{
                            self.badArray.append(urlString)
                            self.mainNewsArray[sender.tag].disLikeCount = self.mainNewsArray[sender.tag].disLikeCount + 1
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
                        let dislikes = self.realm.objects(NewsDisLikes1.self).filter("documentID == %@",urlString)
                        try! self.realm.write() {
                            self.realm.delete(dislikes)
                            self.badArray.remove(at: self.badArray.index(of: urlString)!)
                            self.mainNewsArray[sender.tag].disLikeCount = self.mainNewsArray[sender.tag].disLikeCount - 1
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
        if let url = NSURL(string: newsArray[sender.tag].url) {
            let safariViewController = SFSafariViewController(url: url as URL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @objc func commentTap(sender:UIButton){
        comnum = sender.tag
        performSegue(withIdentifier: "Post", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailnum = indexPath.row
        performSegue(withIdentifier: "Detail", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Post"{
            let newsPostCommentViewController = segue.destination as! NewsPostCommentViewController
            newsPostCommentViewController.newsContents = self.newsArray[comnum]
            newsPostCommentViewController.date = self.date
        }else{
            let newsDetailViewController = segue.destination as! NewsDetailViewController
            newsDetailViewController.mainNews = self.mainNewsArray[detailnum]
            newsDetailViewController.date = self.date
            newsDetailViewController.detailnum = self.detailnum
            newsDetailViewController.dateNum = self.dateNum
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
