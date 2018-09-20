//
//  AlertFlagViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/20.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Eureka
import Firebase
class AlertFlagViewController: FormViewController {
    var db = Firestore.firestore()
    var content: GetDetail!
    var response : GetResponse!
    var num = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let continents = ["ハラスメントな投稿である", "暴力的な投稿である", "嫌がらせを意図する投稿である", "フェイクニュース", "スパム", "無関係な投稿", "ヘイトスピーチ"]
        let continent = ["ハラスメントな投稿である", "暴力的な投稿である", "嫌がらせを意図する投稿である", "フェイクニュース", "スパム", "無関係な投稿", "ヘイトスピーチ","notes"]
        var array = [String:String]()
        
        form +++ SelectableSection<ImageCheckRow<String>>() { section in
            section.header = HeaderFooterView(title: "通報の内容を選択してください")
        }
        
        for option in continents {
            num += 1
            form.last! <<< ImageCheckRow<String>(option){ lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }
        }
        form.last! <<< TextAreaRow("notes") {
            $0.placeholder = "その他の違反がある場合、詳細を入力してください"
            $0.title = "本文"
            $0.textAreaHeight = .dynamic(initialTextViewHeight: 150)
        }
        form.last! <<< ButtonRow(){
            $0.title = "通報する"
            $0.cell.tintColor = UIColor.orange
            }.onCellSelection(){i, to in
                let values = self.form.values()
                print(values)
                for item in continent{
                    if values[item] != nil{
                        array[item] = values[item] as? String
                    }
                }
                print(array)
                self.db.collection("SNS").document(self.content.docID).collection("response").document(self.response.docID).collection("alert").addDocument(data: [
                    "alert" : array
                ]){error in
                    if let error = error {
                        self.alert(message: error.localizedDescription)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
        
        
        // Do any additional setup after loading the view.
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
    
}


