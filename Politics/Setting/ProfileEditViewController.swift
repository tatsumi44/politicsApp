//
//  ProfileEditViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/17.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import RealmSwift
class ProfileEditViewController: FormViewController {
    let realm = try! Realm()
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = realm.objects(Userdata.self)[0]
        form +++
            Section()
            +++ Section("名前を変更")
            <<< TextRow("name") {
                $0.title = "名前"
                //                $0.placeholder = "Placeholder"
                $0.value = user.name
            }
            +++ Section("性別を変更")
            <<< PushRow<String>("sex") {
                $0.title = "性別"
                $0.options = ["girl","boy","other"]
                $0.value = user.sex
                $0.selectorTitle = "Choose an Emoji!"
                }.onChange({ (row) in
                    
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            +++ Section("地域を変更")
            <<< PushRow<String>("place") {
                $0.title = "都道府県"
                $0.options = ["","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                              "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                              "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                              "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                              "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                              "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                              "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
                $0.value = user.place
                $0.selectorTitle = "Choose an Emoji!"
                }.onChange({ (row) in
                    
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            +++ Section("年齢を変更")
            <<< PushRow<String>("age") {
                $0.title = "年齢"
                $0.options = ["","~20歳","20歳~24歳","25歳~29歳","30歳~34歳","35歳~39歳","40歳~44歳","45歳~49歳","50歳~54歳","55歳~59歳","60歳~64歳","65歳~69歳","70歳~74歳","75歳~79歳","80歳以上"]
                $0.value = user.age
                $0.selectorTitle = "Choose an Emoji!"
                }.onChange({ (row) in
                    
                    
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
            +++ Section("変更する")
            <<< ButtonRow(){
                $0.title = "変更する"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection(){i, to in
                    let values = self.form.values()
                    print(values)
                    print(values.count)
                    if values.count != 4{
                        self.alert(message: "個人情報が全て入力されていません")
                    }else{
                        if let name:String = values["name"] as? String,let place:String = values["place"] as? String,let age:String = values["age"] as? String,let sex:String = values["sex"] as? String{
                            try! self.realm.write() {
                                user.name = name
                                user.sex = sex
                                user.place = place
                                user.age = age
                            }
                            self.db.collection("users").document(user.userID).updateData([
                                "name" : name,
                                "place" : place,
                                "sex" : sex,
                                "age" : age
                                ])
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }
                    }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
