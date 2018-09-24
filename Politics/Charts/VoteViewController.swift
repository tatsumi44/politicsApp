//
//  VoteViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/10.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import RealmSwift
import Eureka
import ViewRow
import WCLShineButton
class VoteViewController: FormViewController  {
    //    @IBOutlet weak var titleLabel: UILabel!
    var questions:Qusetions!
    var continents = [String]()
    //    @IBOutlet weak var choiceLabel: UITextField!
    var array = [String:String]()
    let db = Firestore.firestore()
    var answer:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        print(date.string(custom: "YY_MM_dd"))
        continents = questions.array
        form
            +++ Section("質問タイトル")
            <<< LabelRow { row in
                row.title = "\(questions.title!)"
                row.cell.textLabel?.numberOfLines = 0
                row.cell.textLabel?.textColor = UIColor.orange
            }
            
            +++ SelectableSection<ImageCheckRow<String>>() { section in
                section.header = HeaderFooterView(title: "回答を選択してください")
        }
        
        for option in continents {
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }
        }
        
        form.last! <<< ViewRow<UIImageView>("view") { (row) in

            }
            .cellSetup { (cell, row) in
                //  Construct the view for the cell
                cell.textLabel?.textAlignment = .center
                cell.view = UIImageView()
                cell.view?.contentMode = .scaleAspectFit
                cell.contentView.addSubview(cell.view!)
                
                //  Get something to display
                let image = UIImage(named: "mainVote")
                
                cell.view!.image = image
                
                //  Make the image view occupy the entire row:
                cell.viewRightMargin = 0.0
                cell.viewLeftMargin = 0.0
                cell.viewTopMargin = 0.0
                cell.viewBottomMargin = 0.0
                //  Define the cell's height
                cell.height = { return CGFloat(200) }
            }
            .onCellSelection({ (cell, image) in
                print("TAP")
                print(self.form.values())
                let vals = self.form.values()
                for (key,val) in vals{
                    if val != nil{
                        self.answer = key
                    }
                }
                print(self.answer)
                guard self.answer != nil else{
                    self.alert(message: "選択されていません")
                    return
                }

                let realm = try! Realm()
                let user = realm.objects(Userdata.self)
                    self.db.collection(self.nowDate(num: 0)).document(self.questions.questionID).collection(self.answer).document(user[0].userID).setData([
                        "name" : user[0].name,
                        "age" :user[0].age,
                        "place" : user[0].place,
                        "sex" : user[0].sex
                        ])
                    self.db.collection("questions").document(self.questions.questionID).getDocument { (snap, error) in
                        if let error = error{
                            self.alert(message: error.localizedDescription)
                        }else{
                            let data = snap?.data()
                            let todayFlag = data!["\(self.nowDate(num: 0))"]
                            if todayFlag == nil{
                                self.db.collection("questions").document(self.questions.questionID).updateData([
                                    "\(self.nowDate(num: 0))" : true
                                    ])
                            }
                        }
                    }
                    self.performSegue(withIdentifier: "GoResult", sender: nil)
            })
        
        
    }
    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            print("Single Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
        }
        else if row.section === form[1] {
            print("Mutiple Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRows().map({$0.baseValue}))")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//        @IBAction func vote(_ sender: Any) {
//
//
//        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoResult"{
            let chartsResultViewController = segue.destination as! ChartsResultViewController
            chartsResultViewController.questionID = questions.questionID
            chartsResultViewController.questionArray = questions.array
        }
    }
    
}
