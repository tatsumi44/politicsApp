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
class VoteViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate  {
   
    
    
    @IBOutlet weak var titleLabel: UILabel!
    var questions:Qusetions!
    var array = [String]()
    @IBOutlet weak var choiceLabel: UITextField!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        print(date.string(custom: "YY_MM_dd"))
        titleLabel.text = questions.title
        array = questions.array
        let pickerView1 = UIPickerView()
        pickerView1.dataSource = self
        pickerView1.delegate = self
        choiceLabel.inputView = pickerView1
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        toolbar.setItems([doneItem], animated: true)
        choiceLabel.inputAccessoryView = toolbar
        

        // Do any additional setup after loading the view.
    }
    @objc func done() {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choiceLabel.text = array[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func vote(_ sender: Any) {

        let realm = try! Realm()
        let user = realm.objects(Userdata.self)
        if let answer:String = choiceLabel.text{
//            print(user)
            db.collection(nowDate(num: 0)).document(questions.questionID).collection(answer).document(user[0].userID).setData([
                "name" : user[0].name,
                "age" :user[0].age,
                "place" : user[0].place,
                "sex" : user[0].sex
                ])
            db.collection("questions").document(questions.questionID).getDocument { (snap, error) in
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
            performSegue(withIdentifier: "GoResult", sender: nil)
//            print("good")
        }else{
            alert(message: "何か入力して")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoResult"{
            let chartsResultViewController = segue.destination as! ChartsResultViewController
            chartsResultViewController.questionID = questions.questionID
            chartsResultViewController.questionArray = questions.array
        }
    }
    
}
