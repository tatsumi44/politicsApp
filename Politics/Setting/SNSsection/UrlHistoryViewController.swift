//
//  UrlHistoryViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/26.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
class UrlHistoryViewController: TodayViewController {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
//    @IBOutlet weak var mainTable: UITableView!
//    var mainNewsArray = [MainNewsData]()
    var urlArray = [UrlData]()
//    let db = Firestore.firestore()
    
    var sortNum :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        mainTable.dataSource = self
//        getNews()
        getNews(date: "a")
    }
    override func getNews(date: String) {
        print("----------------------------------------------")
        print(urlArray.count)
        for url in urlArray{
            print(url)
            db.collection("news").document(url.dateString).collection(url.urlID).order(by: "date", descending: true).limit(to: 1).getDocuments { (snap, error) in
                
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
//                   let data = snap.
//                    for doc in snap!.documents{
//                        print("aaaaaaaaaaaaaaaaaaaaaaaa")
//                    }
                }
//                for doc in snap!.documents{
//                    if let error = error{
//                        self.alert(message: error.localizedDescription)
//                    }else{
//                        let data = doc.data()
//
//                        self.db.collection("news").document(url.dateString).collection(url.urlID).order(by: "date", descending: true).getDocuments(completion: { (snap, error) in
//                            print("aaaaaaaaaaaaaaaaaaaaa")
//                            let commentCount = snap?.count
//                            self.db.collection("news").document(url.dateString).collection(url.urlID).document("evaluate").collection("good").getDocuments(completion: { (snap, error) in
//                                if let error = error {
//                                    self.alert(message: error.localizedDescription)
//                                }else{
//                                    print("111111111111111111111111111111")
//                                    let goodCount = snap?.count
//                                    self.db.collection("news").document(url.dateString).collection(url.urlID).document("evaluate").collection("bad").getDocuments(completion: { (snap, error) in
//                                        if let error = error{
//                                            self.alert(message: error.localizedDescription)
//                                        }else{
//                                            print("222222222222222222222222222222222")
//                                            let badCount = snap?.count
//                                            let date = data["date"] as! NSDate
//                                            let testFormatter = DateFormatter()
//                                            testFormatter.dateFormat = "yyyy年MM月dd日(E) a h:mm:ss.SSS"
//                                            let dateString = testFormatter.string(from: date as Date)
//                                            self.mainNewsArray.append(MainNewsData(num: self.sortNum, title: data["title"] as! String, url: data["url"] as! String, likeCount: goodCount!, disLikeCount: badCount!, commentCount: commentCount!, date: dateString))
//                                            self.sortNum += 1
//                                        }
//                                        if self.mainNewsArray.count == self.urlArray.count{
//                                            print(self.mainNewsArray)
//                                            print("apple")
//                                            self.mainNewsArray.sort(by: {$0.num > $1.num})
//                                            self.mainTable.reloadData()
//                                        }
//                                    })
//                                }
//                            })
//                        })
//                    }
//                }
            }
        }
    }
    
    func getNews() {
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
