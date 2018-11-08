//
//  StartViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import RealmSwift
import Eureka
import ViewRow
class StartViewController: FormViewController  {

    var sex:String!
    let saveData:UserDefaults = UserDefaults.standard

    var db : Firestore!
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        form
            +++ Section()
            <<< ViewRow<UIImageView>("view") { (row) in
                
                }
                .cellSetup { (cell, row) in
                    //  Construct the view for the cell
                    cell.textLabel?.textAlignment = .center
                    cell.view = UIImageView()
                    cell.view?.contentMode = .scaleAspectFit
                    cell.contentView.addSubview(cell.view!)
                    cell.backgroundColor = UIColor(rgb: (r: 243, g: 243, b: 242))
                    
                    //  Get something to display
                    let image = UIImage(named: "voting")
                    
                    cell.view!.image = image
                    
                    //  Make the image view occupy the entire row:
                    cell.viewRightMargin = 0.0
                    cell.viewLeftMargin = 0.0
                    cell.viewTopMargin = 0.0
                    cell.viewBottomMargin = 0.0
                    //  Define the cell's height
                    cell.height = { return CGFloat(200) }
            }

            +++ Section("プロフィール入力")
            <<< TextRow("name"){
                $0.placeholder = "名前を入力"
        }
            <<< SegmentedRow<String>("sex") { $0.options = ["男性", "女性", "その他"] }
            <<< PushRow<String>("place") {
                $0.title = "都道府県"
                $0.options = ["","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                              "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                              "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                              "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                              "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                              "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                              "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
                $0.value = ""
                $0.selectorTitle = "Choose an Emoji!"
        }
            <<< PushRow<String>("age") {
                $0.title = "年齢"
                $0.options = ["","~20歳","20歳~24歳","25歳~29歳","30歳~34歳","35歳~39歳","40歳~44歳","45歳~49歳","50歳~54歳","55歳~59歳","60歳~64歳","65歳~69歳","70歳~74歳","75歳~79歳","80歳以上"]
                $0.value = ""
                $0.selectorTitle = "Choose an Emoji!"
                }
            <<< ButtonRow(){
                $0.title = "登録する"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection({ i, to in
                    print(self.form.values())
                    let array = self.form.values()
                    guard let name:String = array["name"] as? String,let place:String = array["place"] as? String,let age:String = array["age"] as? String else{
                        self.alert(message: "名前を入力してください")
                        return
                    }
                    guard let sex:String = array["sex"] as? String,sex != "" else{
                        self.alert(message: "性別を入力してください")
                        return
                    }
                    
                    guard place != "" else{
                        self.alert(message: "場所を入力してください")
                        return
                    }
                    guard age != "" else{
                        self.alert(message: "年齢を入力してください")
                        return
                    }
                    print(name)
                    print(sex)
                    print(place)
                    print(age)
   
                    var ref: DocumentReference? = nil
                    ref = self.db.collection("users").addDocument(data: [
                        "name":name,
                        "place":place,
                        "age":age,
                        "sex":sex
                    ]){ err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            let user = Userdata()
                            user.age = age
                            user.name = name
                            user.place = place
                            user.sex = sex
                            user.userID = "\(ref!.documentID)"
                            try! self.realm.write() {
                                self.realm.add(user)
                            }
                            self.saveData.set(true, forKey: "user")
                        }
                    }

                    let tab = self.tabSegue()
                    self.present(tab, animated: true, completion: nil)

                    
                })
        // Do any additional setup after loading the view.
    }
    @objc func done() {
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

