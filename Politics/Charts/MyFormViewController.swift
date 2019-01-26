//
//  MyFormViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/12.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
class MyFormViewController: FormViewController {
    
    let saveData:UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("都道府県を選択してください")
            <<< PushRow<String>() {
                $0.title = "都道府県"
                $0.options = ["","北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
                              "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
                              "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
                              "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
                              "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
                              "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
                              "熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
                $0.value = ""
                $0.selectorTitle = "選択肢一覧"
                }.onChange({ (row) in
                    //                    print(row.value)
                    if let age = row.value{
                        if row.value == ""{
                            self.saveData.removeObject(forKey: "place")
                        }else{
                            self.saveData.set(age, forKey: "place")
                        }
                    }
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                    
            }
            +++ Section("年齢を選択してください")
            <<< PushRow<String>() {
                $0.title = "年齢"
                $0.options = ["","~20歳","20歳~24歳","25歳~29歳","30歳~34歳","35歳~39歳","40歳~44歳","45歳~49歳","50歳~54歳","55歳~59歳","60歳~64歳","65歳~69歳","70歳~74歳","75歳~79歳","80歳以上"]
                $0.value = ""
//                $0.selectorTitle = "Choose an Emoji!"
                }.onChange({ (row) in
                    if let age = row.value{
                        if row.value == ""{
                            self.saveData.removeObject(forKey: "age")
                        }else{
                            self.saveData.set(age, forKey: "age")
                        }
                    }
                    
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
            }
             +++ Section("性別を選択してください")
            <<< PushRow<String>() {
                $0.title = "性別"
                $0.options = ["","男性", "女性", "その他"]
                $0.value = ""
//                $0.selectorTitle = "Choose an Emoji!"
                }.onChange({ (row) in
                    if let age = row.value{
                        if row.value == ""{
                            self.saveData.removeObject(forKey: "sex")
                        }else{
                            self.saveData.set(age, forKey: "sex")
                        }
                    }
                    //                    print(row.value)
                })
                .onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
        }
            <<< ButtonRow(){
                $0.title = "検索"
                $0.cell.tintColor = UIColor.orange
                }.onCellSelection({ i, to in
                    self.navigationController?.popViewController(animated: true)
                })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
