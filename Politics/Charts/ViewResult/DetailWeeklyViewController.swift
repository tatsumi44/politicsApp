//
//  DetailWeeklyViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/06.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Charts
class DetailWeeklyViewController: DemoBaseViewController {
    var maincontentsArray = [mainWeeklyData]()
    var question:Qusetions!
    var contentsArray = [WeeklyData]()
    var dateArray=[String]()
    var numArray = [Double]()
    var dataArray = [String:[Double]]()
    var bgolors = [Any]()
    @IBOutlet weak var mainChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...6{
            dateArray.append(shortNowDate(num: 7 - i))
        }
        print(dateArray)
        let contents = self.contentsArray.sorted(by: {$0.num < $1.num})
        let ques_array = [String](question.array.values)
        for ans in ques_array{
            numArray = [Double]()
            for content in contents{
                print(Double(content.sum))
                numArray.append((Double(content.answerSize[ans]!) / Double(content.sum))*100)
                print(dataArray)
                if numArray.count == 7{
                    numArray.reverse()
                    dataArray[ans] = numArray
                }
                if dataArray.count == question.array.count{
                    print(dataArray)
                }
            }
        }
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleHorizontalCubic,
                        .toggleStepped,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]
        mainChart.delegate = self
        mainChart.chartDescription?.enabled = false
        mainChart.dragEnabled = true
        mainChart.setScaleEnabled(true)
        mainChart.pinchZoomEnabled = true
        
        //下の属性一覧
        let l = mainChart.legend
        //属性表示のタイプ
        l.form = .line
        //属性表示のフォント
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        //属性表示の文字色
        l.textColor = .orange
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        
        //上の文字
        let xAxis = mainChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelCount = dateArray.count - 1
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .orange
        //xAxisの文字をいじるためにはこれが必要
        xAxis.valueFormatter = self
        xAxis.drawAxisLineEnabled = false
        
        //アニメーションの速度
        mainChart.animate(xAxisDuration: 2.5)
        
        self.setDataCount(xValArr: dateArray, yValArr: dataArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension DetailWeeklyViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateArray[Int(value) % dateArray.count]
    }
}

extension DetailWeeklyViewController{
    
    func setDataCount(xValArr: [String], yValArr: [String:[Double]]) {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals4 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals5 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals6 : [ChartDataEntry] = [ChartDataEntry]()
        var yVals7 : [ChartDataEntry] = [ChartDataEntry]()
        let array = [String](question.array.values)
        switch yValArr.count {
        case 3:
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[0]]![i]))
                yVals1.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[1]]![i]))
                yVals2.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[2]]![i]))
                yVals3.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            let set1 = LineChartDataSet(values: yVals1, label: array[0])
            set1.colors = ChartColorTemplates.vordiplom()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            for i in 0..<yValArr.count{
                print("色\(set1.colors[i])")
                bgolors.append(set1.colors[i])
            }
            
            set1.axisDependency = .left
            set1.setColor(bgolors[0] as! UIColor)
            set1.setCircleColor(.white)
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = bgolors[0] as! UIColor
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: array[1])
            set2.axisDependency = .right
            set2.setColor(bgolors[1] as! UIColor)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = bgolors[1] as! UIColor
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
            let set3 = LineChartDataSet(values: yVals3, label: array[2])
            set3.axisDependency = .right
            set3.setColor(bgolors[2] as! UIColor)
            set3.setCircleColor(.white)
            set3.lineWidth = 2
            set3.circleRadius = 3
            set3.fillAlpha = 65/255
            set3.fillColor = bgolors[2] as! UIColor
            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set3.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2, set3,])
            data.setValueTextColor(.black)
            data.setValueFont(.systemFont(ofSize: 9))
            
            mainChart.data = data
        case 4:
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[0]]![i]))
                yVals1.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[1]]![i]))
                yVals2.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[2]]![i]))
                yVals3.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[3]]![i]))
                yVals4.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            let set1 = LineChartDataSet(values: yVals1, label: array[0])
            set1.colors = ChartColorTemplates.vordiplom()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            for i in 0..<yValArr.count{
                print("色\(set1.colors[i])")
                bgolors.append(set1.colors[i])
            }
            
            set1.axisDependency = .left
            set1.setColor(bgolors[0] as! UIColor)
            set1.setCircleColor(.white)
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = bgolors[0] as! UIColor
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: array[1])
            set2.axisDependency = .right
            set2.setColor(bgolors[1] as! UIColor)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = bgolors[1] as! UIColor
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
            let set3 = LineChartDataSet(values: yVals3, label: array[2])
            set3.axisDependency = .right
            set3.setColor(bgolors[2] as! UIColor)
            set3.setCircleColor(.white)
            set3.lineWidth = 2
            set3.circleRadius = 3
            set3.fillAlpha = 65/255
            set3.fillColor = bgolors[2] as! UIColor
            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set3.drawCircleHoleEnabled = false
            
            let set4 = LineChartDataSet(values: yVals3, label: array[2])
            set4.axisDependency = .right
            set4.setColor(bgolors[3] as! UIColor)
            set4.setCircleColor(.white)
            set4.lineWidth = 2
            set4.circleRadius = 3
            set4.fillAlpha = 65/255
            set4.fillColor = bgolors[3] as! UIColor
            set4.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set4.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2, set3, set4])
            data.setValueTextColor(.black)
            data.setValueFont(.systemFont(ofSize: 9))
            
            mainChart.data = data
        case 5:
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[0]]![i]))
                yVals1.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[1]]![i]))
                yVals2.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[2]]![i]))
                yVals3.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[3]]![i]))
                yVals4.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[4]]![i]))
                yVals5.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            let set1 = LineChartDataSet(values: yVals1, label: array[0])
            set1.colors = ChartColorTemplates.vordiplom()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            for i in 0..<yValArr.count{
                print("色\(set1.colors[i])")
                bgolors.append(set1.colors[i])
            }
            
            set1.axisDependency = .left
            set1.setColor(bgolors[0] as! UIColor)
            set1.setCircleColor(.white)
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = bgolors[0] as! UIColor
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: array[1])
            set2.axisDependency = .right
            set2.setColor(bgolors[1] as! UIColor)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = bgolors[1] as! UIColor
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
            let set3 = LineChartDataSet(values: yVals3, label: array[2])
            set3.axisDependency = .right
            set3.setColor(bgolors[2] as! UIColor)
            set3.setCircleColor(.white)
            set3.lineWidth = 2
            set3.circleRadius = 3
            set3.fillAlpha = 65/255
            set3.fillColor = bgolors[2] as! UIColor
            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set3.drawCircleHoleEnabled = false
            
            let set4 = LineChartDataSet(values: yVals4, label: array[3])
            set4.axisDependency = .right
            set4.setColor(bgolors[3] as! UIColor)
            set4.setCircleColor(.white)
            set4.lineWidth = 2
            set4.circleRadius = 3
            set4.fillAlpha = 65/255
            set4.fillColor = bgolors[3] as! UIColor
            set4.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set4.drawCircleHoleEnabled = false
            
            let set5 = LineChartDataSet(values: yVals5, label: array[4])
            set5.axisDependency = .right
            set5.setColor(bgolors[4] as! UIColor)
            set5.setCircleColor(.white)
            set5.lineWidth = 2
            set5.circleRadius = 3
            set5.fillAlpha = 65/255
            set5.fillColor = bgolors[4] as! UIColor
            set5.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set5.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2, set3, set4, set5])
            data.setValueTextColor(.black)
            data.setValueFont(.systemFont(ofSize: 9))
            
            mainChart.data = data
        case 6:
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[0]]![i]))
                yVals1.append(dataEntry)
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[1]]![i]))
                yVals2.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[2]]![i]))
                yVals3.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[3]]![i]))
                yVals4.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[4]]![i]))
                yVals5.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[5]]![i]))
                yVals6.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            let set1 = LineChartDataSet(values: yVals1, label: array[0])
            set1.colors = ChartColorTemplates.vordiplom()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            for i in 0..<yValArr.count{
                print("色\(set1.colors[i])")
                bgolors.append(set1.colors[i])
            }
            
            set1.axisDependency = .left
            set1.setColor(bgolors[0] as! UIColor)
            set1.setCircleColor(.white)
            //            set1.valueColors = [UIcolor.balck]
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = bgolors[0] as! UIColor
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: array[1])
            set2.axisDependency = .right
            set2.setColor(bgolors[1] as! UIColor)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = bgolors[1] as! UIColor
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
            let set3 = LineChartDataSet(values: yVals3, label: array[2])
            set3.axisDependency = .right
            set3.setColor(bgolors[2] as! UIColor)
            set3.setCircleColor(.white)
            set3.lineWidth = 2
            set3.circleRadius = 3
            set3.fillAlpha = 65/255
            set3.fillColor = bgolors[2] as! UIColor
            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set3.drawCircleHoleEnabled = false
            
            let set4 = LineChartDataSet(values: yVals4, label: array[3])
            set4.axisDependency = .right
            set4.setColor(bgolors[3] as! UIColor)
            set4.setCircleColor(.white)
            set4.lineWidth = 2
            set4.circleRadius = 3
            set4.fillAlpha = 65/255
            set4.fillColor = bgolors[3] as! UIColor
            set4.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set4.drawCircleHoleEnabled = false
            
            let set5 = LineChartDataSet(values: yVals5, label: array[4])
            set5.axisDependency = .right
            set5.setColor(bgolors[4] as! UIColor)
            set5.setCircleColor(.white)
            set5.lineWidth = 2
            set5.circleRadius = 3
            set5.fillAlpha = 65/255
            set5.fillColor = bgolors[4] as! UIColor
            set5.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set5.drawCircleHoleEnabled = false
            
            let set6 = LineChartDataSet(values: yVals6, label: array[5])
            set6.axisDependency = .right
            set6.setColor(bgolors[5] as! UIColor)
            set6.setCircleColor(.white)
            set6.lineWidth = 2
            set6.circleRadius = 3
            set6.fillAlpha = 65/255
            set6.fillColor = bgolors[5] as! UIColor
            set6.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set6.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2, set3, set4, set5, set6])
            data.setValueTextColor(.black)
            data.setValueFont(.systemFont(ofSize: 9))
            
            mainChart.data = data
        case 7:
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[0]]![i]))
                yVals1.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[1]]![i]))
                yVals2.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[2]]![i]))
                yVals3.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[3]]![i]))
                yVals4.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[4]]![i]))
                yVals5.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[5]]![i]))
                yVals6.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            for i in 0 ..< xValArr.count {
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(yValArr[array[6]]![i]))
                yVals7.append(dataEntry) //(ChartDataEntry(x: Double(i), y: dollars1[i]))
            }
            let set1 = LineChartDataSet(values: yVals1, label: array[0])
            set1.colors = ChartColorTemplates.vordiplom()
                + ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            for i in 0..<yValArr.count{
                print("色\(set1.colors[i])")
                bgolors.append(set1.colors[i])
            }
            
            set1.axisDependency = .left
            set1.setColor(bgolors[0] as! UIColor)
            set1.setCircleColor(.white)
            set1.lineWidth = 2
            set1.circleRadius = 3
            set1.fillAlpha = 65/255
            set1.fillColor = bgolors[0] as! UIColor
            set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set1.drawCircleHoleEnabled = false
            
            let set2 = LineChartDataSet(values: yVals2, label: array[1])
            set2.axisDependency = .right
            set2.setColor(bgolors[1] as! UIColor)
            set2.setCircleColor(.white)
            set2.lineWidth = 2
            set2.circleRadius = 3
            set2.fillAlpha = 65/255
            set2.fillColor = bgolors[1] as! UIColor
            set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set2.drawCircleHoleEnabled = false
            
            let set3 = LineChartDataSet(values: yVals3, label: array[2])
            set3.axisDependency = .right
            set3.setColor(bgolors[2] as! UIColor)
            set3.setCircleColor(.white)
            set3.lineWidth = 2
            set3.circleRadius = 3
            set3.fillAlpha = 65/255
            set3.fillColor = bgolors[2] as! UIColor
            set3.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set3.drawCircleHoleEnabled = false
            
            let set4 = LineChartDataSet(values: yVals4, label: array[3])
            set4.axisDependency = .right
            set4.setColor(bgolors[3] as! UIColor)
            set4.setCircleColor(.white)
            set4.lineWidth = 2
            set4.circleRadius = 3
            set4.fillAlpha = 65/255
            set4.fillColor = bgolors[3] as! UIColor
            set4.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set4.drawCircleHoleEnabled = false
            
            let set5 = LineChartDataSet(values: yVals5, label: array[4])
            set5.axisDependency = .right
            set5.setColor(bgolors[4] as! UIColor)
            set5.setCircleColor(.white)
            set5.lineWidth = 2
            set5.circleRadius = 3
            set5.fillAlpha = 65/255
            set5.fillColor = bgolors[4] as! UIColor
            set5.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set5.drawCircleHoleEnabled = false
            
            let set6 = LineChartDataSet(values: yVals6, label: array[5])
            set6.axisDependency = .right
            set6.setColor(bgolors[5] as! UIColor)
            set6.setCircleColor(.white)
            set6.lineWidth = 2
            set6.circleRadius = 3
            set6.fillAlpha = 65/255
            set6.fillColor = bgolors[5] as! UIColor
            set6.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set6.drawCircleHoleEnabled = false
            
            let set7 = LineChartDataSet(values: yVals7, label: array[6])
            set7.axisDependency = .right
            set7.setColor(bgolors[6] as! UIColor)
            set7.setCircleColor(.white)
            set7.lineWidth = 2
            set7.circleRadius = 3
            set7.fillAlpha = 65/255
            set7.fillColor = bgolors[6] as! UIColor
            set7.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
            set7.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2, set3, set4, set5, set6, set7])
            data.setValueTextColor(.black)
            data.setValueFont(.systemFont(ofSize: 9))
            
            mainChart.data = data
        default:
            return
        }
    }
    
}
