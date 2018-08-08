//
//  StartViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class StartViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    var sex:String!
    let saveData:UserDefaults = UserDefaults.standard
    let placeArray = [
        "北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県",
        "茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県",
        "新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県",
        "静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県",
        "奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県",
        "徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県",
        "熊本県","大分県","宮崎県","鹿児島県","沖縄県"
    ]
    let ageArray = [
    "~20歳","20歳~24歳","25歳~29歳","30歳~34歳","35歳~39歳","40歳~44歳","45歳~49歳","50歳~54歳","55歳~59歳","60歳~64歳","65歳~69歳","70歳~74歳","75歳~79歳","80歳以上"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView1 = UIPickerView()
        let pickerView2 = UIPickerView()
        pickerView1.tag = 1
        pickerView2.tag = 2
        pickerView1 .dataSource = self
        pickerView2.dataSource = self
        pickerView1.delegate = self
        pickerView2.delegate = self
        userName.delegate = self
        placeTextField.inputView = pickerView1
        ageTextField.inputView = pickerView2
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        placeTextField.inputAccessoryView = toolbar
        ageTextField.inputAccessoryView = toolbar
        
        // Do any additional setup after loading the view.
    }
    @objc func done() {
        view.endEditing(true)
    }
    
 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return placeArray.count
        case 2:
            return ageArray.count
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return placeArray[row]
        case 2:
            return ageArray[row]
        default:
            return "nil"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            placeTextField.text = placeArray[row]
        case 2:
            ageTextField.text = ageArray[row]
        default:
            return
        }
    }
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sex = "boy"
        case 1:
            sex = "girl"
        case 3:
            sex = "other"
        default:
            return
        }
    }
    
    @IBAction func decide(_ sender: Any) {
        if let name = userName.text,let place = placeTextField.text,let age = ageTextField.text,sex != nil{
          let id = randomString(length: 30)
            let userArray = ["id":id,"name":name,"place":place,"age":age,"sex":sex]
            saveData.set(userArray, forKey: "user")
            performSegue(withIdentifier: "GoChart", sender: nil)
        }else{
            alert(message: "何かが記入されていません")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

