//
//  VoteListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import RealmSwift
import FirebaseUI
import PKHUD
class VoteListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var num: Int!
    let realm = try! Realm()
    var flag:Bool!
    var array = [String:String]()
    var db: Firestore!
    var questionArray = [Qusetions]()
    var idArray = [String]()
    @IBOutlet weak var mainTable: UITableView!
    
    
    let button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
        self.mainTable.register(UINib(nibName: "TopListTableViewCell", bundle: nil), forCellReuseIdentifier: "TopListTableViewCell")
        mainTable.dataSource = self
        mainTable.delegate  = self
        //        let realm = try! Realm()
        //        let tanakas = realm.objects(Vote.self)
        //
        //        tanakas.forEach { tanaka in
        //            try! realm.write() {
        //                realm.delete(tanaka)
        //            }
        //        }
        iconCreate()
        
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "small_icon.png"))
        HUD.show(.progress)
        self.navigationItem.hidesBackButton = true
//        hidesBottomBarWhenPushed = true
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        print(statusBarHeight)
        print(navBarHeight!)
        let navheight = statusBarHeight + navBarHeight!
        let tabheight = tabBarController?.tabBar.frame.size.height
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navBarHeight = navheight
        appDelegate.tabheight = tabheight
        //        let button = UIButton()
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        button.frame = CGRect(x:mainBoundSize.width - 120, y:mainBoundSize.height - tabheight! - 120,
                              width:100, height:100)
        button.setTitle("過去のデータ", for:UIControlState.normal)
//        button.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.hex(string: "#EE983F", alpha: 1), for: .normal)
        button.backgroundColor = UIColor.hex(string: "#1167C0", alpha: 1)
        button.layer.cornerRadius = 50
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(self.oldData), for: .touchUpInside)
        self.view.addSubview(button)
        
        db = Firestore.firestore()
        db.collection("questions").whereField("flag", isEqualTo: true).getDocuments { (snap1, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                for doc in snap1!.documents{
                    let data = doc.data()
                    let docID = doc.documentID
                    let title = data["main_title"] as! String
                    self.db.collection("questions").document(docID).collection("answer").getDocuments(completion: { (snap, error) in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            self.array = [String:String]()
                            for doc in snap!.documents{
                                let data1 = doc.data()
                                let docID1 = doc.documentID
                                self.array[docID1] = data1["answer"] as? String
                            }
                            self.questionArray.append(Qusetions(array: self.array, title: title, questionID: docID))
                            print(self.questionArray)
                            if self.questionArray.count == snap1?.count{
                                self.questionArray.reverse()
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.questionArray = self.questionArray
                                self.mainTable.reloadData()
                                HUD.hide()
                                self.button.isHidden = false
                            }
                        }
                    })
                }
            }
        }
    }
    
     func iconCreate() {
        print("呼ばれてるよ")
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let item = UIBarButtonItem(customView: view1)
        self.navigationItem.leftBarButtonItem = item
        let iconImageView = UIImageView(frame: CGRect(x: 2.5, y: 5, width: 35, height: 35))
        iconImageView.layer.cornerRadius = 35/2
        iconImageView.layer.masksToBounds = true
        let iconBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //        iconBtn.backgroundColor = UIColor.red
        iconBtn.addTarget(self, action: #selector(VoteListViewController.iconTap(_:)), for: .touchUpInside)
        view1.addSubview(iconBtn)
        let user = realm.objects(Userdata.self)[0]
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child("image/profile/\(user.userID).jpg")
        iconImageView.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        view1.addSubview(iconImageView)
    }
    
    @objc func iconTap(_ sender: UIButton){
        print("iconTap")
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        hidesBottomBarWhenPushed = false
//        tabBarController?.tabBar.isHidden = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func oldData(){
//        hidesBottomBarWhenPushed = true
        performSegue(withIdentifier: "oldData", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopListTableViewCell") as! TopListTableViewCell
        if let title = questionArray[indexPath.row].title{
            cell.contentLabel.text = title
            cell.subLabel.textColor = UIColor.hex(string: "#1167C0", alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == questionArray.count - 1{
            button.isHidden = true
        }else{
            button.isHidden = false
        }
        //        print(indexPath.row)
        //        guard tableView.cellForRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)) != nil else {
        //            return
        //        }
        
        // ここでリフレッシュのメソッドを呼ぶ
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        let result = realm.objects(Vote.self).filter("questionID == %@",self.questionArray[num].questionID)
        if result.count != 0{
            //            let result1 = realm.objects(Vote.self).last
            //            print(result1!.voteDate)
            //            let f = DateFormatter()
            //            f.dateFormat = "yyyy/MM/dd"
            //            let tomorrow: Date = Date(timeIntervalSinceNow: 60*60*9)
            //            if f.string(from: result1!.voteDate) == f.string(from: tomorrow){
            //                self.alert(message: "投票内容を変更しますか？")
            let alert: UIAlertController = UIAlertController(title: "本日は投票されています", message: "投票内容を変更しますか？", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
                self.flag = true
                print(self.flag)
//                self.hidesBottomBarWhenPushed = true
                self.performSegue(withIdentifier: "GoVote", sender: nil)
                if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
                }
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            //
            //            }else{
            //                flag = false
            //                performSegue(withIdentifier: "GoVote", sender: nil)
            //                if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            //                    tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            //                }
            //            }
            //            print(tomorrow)
        }else{
            flag = false
            print(self.flag)
//            hidesBottomBarWhenPushed = true
            performSegue(withIdentifier: "GoVote", sender: nil)
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoVote"{
            let voteviewController = segue.destination as! VoteViewController
            voteviewController.questions = self.questionArray[num]
            voteviewController.flag = self.flag
        }
    }
}
