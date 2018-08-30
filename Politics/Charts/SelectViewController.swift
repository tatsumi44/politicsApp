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
    var mainQuestionArray = [String:[Qusetions]]()
    var db: Firestore!
    var questionArray = [Qusetions]()
    var idArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        for i in 0..<7{
            db.collection("questions").whereField(nowDate(num: i), isEqualTo: true).getDocuments { (snap, error) in
                if let error = error{
                    //                    self.alert(message: error.localizedDescription)
                    print(error.localizedDescription)
                }else{
                    for doc in snap!.documents{
                        self.idArray.append(doc.documentID)
                        let data = doc.data()
                        self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: doc.documentID))
                    }
                    
                    self.mainQuestionArray["\(self.nowDate(num: i))"] = self.questionArray
                    if self.mainQuestionArray.count == 7{
                        print(self.mainQuestionArray)
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.mainQuestionArray = self.mainQuestionArray
//                        self.performSegue(withIdentifier: "Result", sender: nil)
                    }
                    self.questionArray = [Qusetions]()
                    HUD.hide()
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
