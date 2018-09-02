//
//  ChartsResultViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/11.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import Charts
import PKHUD
class ChartsResultViewController: DemoBaseViewController,UITableViewDataSource {
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var mainTable: UITableView!
    
    let db = Firestore.firestore()
    var questionID: String!
    var questionArray = [String]()
    var numArray = [String:Double]()
    var sum:Double = 0
    var count = 0
    var resultArray = [ChartResult]()
    let saveData:UserDefaults = UserDefaults.standard
    var array = [String:String]()
    var firstAppear: Bool = false
    var day = "apple"
    var bgolors = [Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.show(.progress)
        self.mainTable.register(UINib(nibName: "ChartsResultListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChartsResultListTableViewCell")
        print("今日は\(day)")
        if day == "apple"{
            day = nowDate(num: 0)
        }
        mainTable.dataSource = self
        self.saveData.removeObject(forKey: "place")
        self.saveData.removeObject(forKey: "age")
        self.saveData.removeObject(forKey: "sex")
        for party in questionArray{
            db.collection(day).document(questionID).collection(party).getDocuments { (snap, error) in
                if let error = error{
                    self.alert(message: error.localizedDescription)
                }else{
                    print("\(party)の投票数は\(snap!.count)です")
                    self.sum = self.sum + Double(snap!.count)
                    if snap!.count != 0{
                        self.numArray["\(party)"] = Double(snap!.count)
                    }
                    self.count += 1
                    if self.count == self.questionArray.count{
                        print(self.sum)
                        print(self.numArray)
                        for (key,value) in self.numArray{
                            if value != 0.0{
                                let val = (value/self.sum) * 100
                                self.numArray[key] = val
                                self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                            }
                        }
                        self.setDataCount(self.numArray.count, range: 100)
                        let centerText = NSMutableAttributedString(string: "投票数 : \(Int(self.sum))")
                        self.pieChart.centerAttributedText = centerText
                        print(self.resultArray)
                        self.resultArray.sort(by: {$0.num1 > $1.num1})
                        self.mainTable.reloadData()
                        HUD.hide()
                        print(self.numArray)
                        self.count = 0
                        self.sum = 0.0
                        self.firstAppear = true
                    }
                }
                
            }
        }
        self.options = [.toggleValues,
                        .toggleXValues,
                        .togglePercent,
                        .toggleHole,
                        .toggleIcons,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .drawCenter,
                        .saveToGallery,
                        .toggleData]
        self.setup(pieChartView: self.pieChart)
        self.pieChart.delegate = self
        let l = self.pieChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .center
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        self.pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        charts1?.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        self.setDataCount(5, range: 100)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let place = saveData.object(forKey: "place"){
            array["place"] = place as? String
        }
        if let age = saveData.object(forKey: "age"){
            array["age"] = age as? String
        }
        if let sex = saveData.object(forKey: "sex"){
            array["sex"] = sex as? String
        }
        let values = [String](array.values)
        if values.count != 0{
            title = "\(values.joined(separator: "&"))でソート"
        }else{
            title = "全データ"
        }
        print(array)
        print(array.count)
        if firstAppear == true{
            resultArray = [ChartResult]()
            numArray = [String:Double]()
            updateChartData()
        }
        
        //
    }
    override func updateChartData() {
        HUD.show(.progress)
        if self.shouldHideData {
            pieChart.data = nil
            return
        }
        var dicKeys = [String](array.keys)
        var dicVal = [String](array.values)
        switch array.count {
        case 0:
            for party in questionArray{
                db.collection(day).document(questionID).collection(party).getDocuments { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        print("\(party)の投票数は\(snap!.count)です")
                        self.sum = self.sum + Double(snap!.count)
                        if snap!.count != 0{
                            self.numArray["\(party)"] = Double(snap!.count)
                        }
                        self.count += 1
                        if self.count == self.questionArray.count{
                            print(self.sum)
                            print(self.numArray)
                            for (key,value) in self.numArray{
                                if value != 0.0{
                                    let val = (value/self.sum) * 100
                                    self.numArray[key] = val
                                    self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                                }
                            }
                            self.resultArray.sort(by: {$0.num1 > $1.num1})
                            self.resultArray.forEach({ (diff) in
                                print("\(diff.title!) \(diff.num1!)")
                            })
                            self.setDataCount(self.numArray.count, range: 100)
                            let centerText = NSMutableAttributedString(string: "投票数 : \(Int(self.sum))")
                            self.pieChart.centerAttributedText = centerText
                            print(self.resultArray)
                            self.mainTable.reloadData()
                            HUD.hide()
                            print(self.numArray)
                            dicVal = []
                            dicKeys = []
                            self.count = 0
                            self.sum = 0.0
                        }
                    }
                }
            }
        case 1:
            for party in questionArray{
                db.collection(day).document(questionID).collection(party).whereField(dicKeys[0], isEqualTo: dicVal[0]).getDocuments { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        print("\(party)の投票数は\(snap!.count)です")
                        self.sum = self.sum + Double(snap!.count)
                        if snap!.count != 0{
                            self.numArray["\(party)"] = Double(snap!.count)
                            print("1\(self.numArray)")
                        }
                        self.count += 1
                        if self.count == self.questionArray.count{
                            print(self.sum)
                            print(self.numArray)
                            for (key,value) in self.numArray{
                                if value != 0.0{
                                    let val = (value/self.sum) * 100
                                    self.numArray[key] = val
                                    self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                                }
                            }
                            self.resultArray.sort(by: {$0.num1 > $1.num1})
                            self.resultArray.forEach({ (diff) in
                                print("\(diff.title!) \(diff.num1!)")
                            })
                            self.setDataCount(self.numArray.count, range: 100)
                            let centerText = NSMutableAttributedString(string: "投票数 : \(Int(self.sum))")
                            self.pieChart.centerAttributedText = centerText
                            print(self.resultArray)
                            self.mainTable.reloadData()
                            HUD.hide()
                            print(self.numArray)
                            self.saveData.removeObject(forKey: "place")
                            self.saveData.removeObject(forKey: "age")
                            self.saveData.removeObject(forKey: "sex")
                            self.array = [:]
                            dicVal = []
                            dicKeys = []
                            self.count = 0
                            self.sum = 0.0
                        }
                    }
                }
            }
        case 2:
            for party in questionArray{
                db.collection(day).document(questionID).collection(party).whereField(dicKeys[0], isEqualTo: dicVal[0]).whereField(dicKeys[1], isEqualTo: dicVal[1]).getDocuments { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        print("\(party)の投票数は\(snap!.count)です")
                        self.sum = self.sum + Double(snap!.count)
                        if snap!.count != 0{
                            self.numArray["\(party)"] = Double(snap!.count)
                        }
                        self.count += 1
                        if self.count == self.questionArray.count{
                            print(self.sum)
                            print(self.numArray)
                            for (key,value) in self.numArray{
                                if value != 0.0{
                                    let val = (value/self.sum) * 100
                                    self.numArray[key] = val
                                    print("2\(self.numArray)")
                                    self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                                }
                            }
                            self.resultArray.sort(by: {$0.num1 > $1.num1})
                            self.resultArray.forEach({ (diff) in
                                print("\(diff.title!) \(diff.num1!)")
                            })
                            self.setDataCount(self.numArray.count, range: 100)
                            let centerText = NSMutableAttributedString(string: "投票数 : \(Int(self.sum))")
                            self.pieChart.centerAttributedText = centerText
                            print(self.resultArray)
                            self.mainTable.reloadData()
                            HUD.hide()
                            print(self.numArray)
                            self.saveData.removeObject(forKey: "place")
                            self.saveData.removeObject(forKey: "age")
                            self.saveData.removeObject(forKey: "sex")
                            self.array = [:]
                            dicVal = []
                            dicKeys = []
                            self.count = 0
                            self.sum = 0.0
                        }
                    }
                }
            }
        case 3:
            for party in questionArray{
                db.collection(day).document(questionID).collection(party).whereField(dicKeys[0], isEqualTo: dicVal[0]).whereField(dicKeys[1], isEqualTo: dicVal[1]).whereField(dicKeys[2], isEqualTo: dicVal[2]).getDocuments { (snap, error) in
                    if let error = error{
                        self.alert(message: error.localizedDescription)
                    }else{
                        print("\(party)の投票数は\(snap!.count)です")
                        self.sum = self.sum + Double(snap!.count)
                        if snap!.count != 0{
                            self.numArray["\(party)"] = Double(snap!.count)
                        }
                        self.count += 1
                        if self.count == self.questionArray.count{
                            print(self.sum)
                            print(self.numArray)
                            for (key,value) in self.numArray{
                                if value != 0.0{
                                    let val = (value/self.sum) * 100
                                    self.numArray[key] = val
                                    self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                                }
                            }
                            self.resultArray.sort(by: {$0.num1 > $1.num1})
                            self.resultArray.forEach({ (diff) in
                                print("\(diff.title!) \(diff.num1!)")
                            })
                            self.setDataCount(self.numArray.count, range: 100)
                            let centerText = NSMutableAttributedString(string: "投票数 : \(Int(self.sum))")
                            self.pieChart.centerAttributedText = centerText
                            print(self.resultArray)
                            self.mainTable.reloadData()
                            HUD.hide()
                            print(self.numArray)
                            self.saveData.removeObject(forKey: "place")
                            self.saveData.removeObject(forKey: "age")
                            self.saveData.removeObject(forKey: "sex")
                            self.array = [:]
                            dicVal = []
                            dicKeys = []
                            self.count = 0
                            self.sum = 0.0
                        }
                    }
                }
            }
        default:
            return
        }
        self.options = [.toggleValues,
                        .toggleXValues,
                        .togglePercent,
                        .toggleHole,
                        .toggleIcons,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .spin,
                        .drawCenter,
                        .saveToGallery,
                        .toggleData]
        self.setup(pieChartView: self.pieChart)
        self.pieChart.delegate = self
        let l = self.pieChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .center
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        self.pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        saveData.removeObject(forKey: "place")
        saveData.removeObject(forKey: "age")
        saveData.removeObject(forKey: "sex")
        array = [:]
        
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        var array : [PieChartDataEntry] = [PieChartDataEntry]()
        for (key,value) in self.numArray{
            let entries = PieChartDataEntry(value: Double(value) ,
                                            label: key)
            array.append(entries)
        }
//        array.sort(by: {$0.value < $1.value})
        let set = PieChartDataSet(values: array, label: "投票結果")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        for i in 0..<count{
            print("色\(set.colors[i])")
            bgolors.append(set.colors[i])
        }
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        //チャートの表示内容のフォントサイズやフォントカラー
        data.setValueFont(.systemFont(ofSize: 12, weight: .light))
        data.setValueTextColor(.black)
        
        pieChart.data = data
        pieChart.highlightValues(nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return numArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartsResultListTableViewCell", for: indexPath) as! ChartsResultListTableViewCell
        let color = bgolors[indexPath.row] as? UIColor
        cell.bgView.layer.borderColor = color?.cgColor
        cell.bgView.layer.borderWidth = 4
        cell.bgView.layer.cornerRadius = 4
        cell.bgView.layer.masksToBounds = true
//        cell.numView.backgroundColor = bgolors[indexPath.row] as? UIColor
        cell.titleLabel.text = resultArray[indexPath.row].title
        cell.countLabel.text = "投票数 \(resultArray[indexPath.row].num1!)票"
        cell.percentLabel.text = "\((round(resultArray[indexPath.row].percent * 10)/10))%"
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

