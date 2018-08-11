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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        for party in questionArray{
            db.collection(nowDate(num: 0)).document(questionID).collection(party).getDocuments { (snap, error) in
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
                                var val = (value/self.sum) * 100
                                self.numArray[key] = val
                                self.resultArray.append(ChartResult(title: key, num1: Int(value), percent: val))
                            }
                        }
                        self.setDataCount(self.numArray.count, range: 100)
                        print(self.resultArray)
                        self.mainTable.reloadData()
                        print(self.numArray)
                    }
                }
                
            }
        }
//        pieChart.drawEntryLabelsEnabled = false
        pieChart.centerText = "投票結果"
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
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        self.pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        self.setDataCount(5, range: 100)
        // Do any additional setup after loading the view.
    }
    func setDataCount(_ count: Int, range: UInt32) {
        
        var array : [PieChartDataEntry] = [PieChartDataEntry]()
        for (key,value) in self.numArray{
            let entries = PieChartDataEntry(value: Double(value) ,
                                            label: key)
            array.append(entries)
        }
        let set = PieChartDataSet(values: array, label: "投票結果")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
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
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView.tag == 1{
//            return numArray.count
//        }
//        return 10
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ChartsResultTableViewCell
//        if tableView.tag == 1{
//            cell.choiceLabel.text = resultArray[indexPath.row].title
//            cell.numberLabel.text = "\(resultArray[indexPath.row].num1)票"
//            cell.percentageLabel.text = "\(resultArray[indexPath.row].percent)%"
//
//        }
//        return cell
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if tableView.tag == 1{
                    return numArray.count
                }
                return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! ChartsResultTableViewCell
                if tableView.tag == 1{
                    cell.choiceLabel.text = resultArray[indexPath.row].title
                    cell.numberLabel.text = "投票数\(resultArray[indexPath.row].num1!)票"
                    cell.percentageLabel.text = "\(resultArray[indexPath.row].percent)%"
        
                }
                return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

