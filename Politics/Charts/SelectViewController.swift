//
//  SelectViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/13.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
class SelectViewController: UIViewController {
    
    @IBOutlet weak var voteBtn: UIButton!
    
    @IBOutlet weak var resultBtn: UIButton!
    @IBOutlet weak var regurarlyBtn: UIButton!
    var mainQuestionArray = [String:[Qusetions]]()
    var db: Firestore!
    var questionArray = [Qusetions]()
    var idArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "small_icon.png"))
        voteBtn.layer.borderColor = UIColor.orange.cgColor
        voteBtn.layer.borderWidth = 4
        voteBtn.layer.cornerRadius = 8
        voteBtn.layer.masksToBounds = true
        resultBtn.layer.borderColor = UIColor.orange.cgColor
        resultBtn.layer.borderWidth = 4
        resultBtn.layer.cornerRadius = 8
        resultBtn.layer.masksToBounds = true
        regurarlyBtn.layer.borderColor = UIColor.orange.cgColor
        regurarlyBtn.layer.borderWidth = 4
        regurarlyBtn.layer.cornerRadius = 8
        regurarlyBtn.layer.masksToBounds = true
        HUD.show(.progress)
        self.navigationItem.hidesBackButton = true
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        print(statusBarHeight)
        print(navBarHeight!)
        let navheight = statusBarHeight + navBarHeight!
        let tabheight = tabBarController?.tabBar.frame.size.height
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navBarHeight = navheight
        appDelegate.tabheight = tabheight
        db = Firestore.firestore()
        db.collection("questions").getDocuments { (snap, error) in
            if let error = error{
                self.alert(message: error.localizedDescription)
                print(error.localizedDescription)
            }else{
                for doc in snap!.documents{
                    let data = doc.data()
                    self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: doc.documentID))
                }
                if self.questionArray.count == snap?.count{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.questionArray = self.questionArray
                    HUD.hide()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
