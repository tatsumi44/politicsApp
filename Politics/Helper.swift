//
//  Helper.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftDate
import Eureka
extension UIViewController{
    
    @objc func  showingKeybord(notification: Notification) {
        if let keybordHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
            self.view.frame.origin.y = -keybordHeight
        }
    }
    
    @objc func hidingKeyboard(){
        self.view.frame.origin.y = 0
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        _ = Calendar(identifier: .gregorian) // グレゴリオ歴
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    func newsurlPath(newsURL:String)->String{
    return newsURL.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "")
    }
    
    
    
    struct PostDetail {
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var url:String!
        var date:NSDate!
        init(title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,url:String,date:NSDate) {
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.url = url
            self.date = date
        }
    }
    struct MiddleGetDtail {
        var num:Int!
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var docID:String!
        var url:String!
        var date:NSDate!
        init(num:Int,title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,docID:String,url:String,date:NSDate) {
            self.num = num
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.docID = docID
            self.url = url
            self.date = date
        }
    }
    
    struct GetDetail {
        var num: Int!
        var title:String!
        var contents:String!
        var tagArray:[String:Int64]!
        var uid:String!
        var username:String!
        var docID:String!
        var url:String!
        var likeCount:Int!
        var disLikeCount:Int!
        var commentCount:Int!
        var date:NSDate!
        init(num:Int,title:String,contents:String,tagArray:[String:Int64],uid:String,username:String,docID:String,url:String,likeCount:Int,disLikeCount:Int,commentCount:Int,date:NSDate) {
            self.num = num
            self.title = title
            self.contents = contents
            self.tagArray = tagArray
            self.uid = uid
            self.username = username
            self.docID = docID
            self.url = url
            self.likeCount = likeCount
            self.disLikeCount = disLikeCount
            self.commentCount = commentCount
            self.date = date
        }
    }
    struct weeklyData {
        var docID:String!
        var title:String!
        var questions:[String]!
        var date:String!
        init(docID:String,title:String,questions:[String],date:String) {
            self.docID = docID
            self.title = title
            self.questions = questions
            self.date = date
        }
    }
    
    struct mainWeeklyData {
        var docID:String!
        var title:String!
        var question:String!
        var questionCount:Int!
        var date:String!
        init(docID:String,title:String,question:String,questionCount:Int,date:String) {
            self.docID = docID
            self.title = title
            self.question = question
            self.questionCount = questionCount
            self.date = date
        }
    }
    
    struct GetResponse{
        var docID:String!
        var comment:String!
        var uid:String!
        var name:String!
        var opponentName:String!
        var opponentUid:String!
        var opponentDocID:String!
        var alertNum:Int!
        var date:NSDate!
        init(docID:String,comment:String,uid:String,name:String,opponentName:String,opponentUid:String,opponentDocID:String,alertNum:Int,date:NSDate) {
            self.docID = docID
            self.comment = comment
            self.uid = uid
            self.name = name
            self.opponentName = opponentName
            self.opponentUid = opponentUid
            self.opponentDocID = opponentDocID
            self.alertNum = alertNum
            self.date = date
        }
    }
    
    struct PostDetailWihtoutTag {
        var title:String!
        var contents:String!
        var date:NSDate!
        init(title:String,contents:String,date:NSDate) {
            self.title = title
            self.contents = contents
            self.date = date
        }
    }
    struct NewsData {
        var num: Int!
        var title:String!
        var url:String!
        var date:String!
        init(num: Int,title:String,url:String,date:String) {
            self.num = num
            self.title = title
            self.url = url
            self.date = date
        }
    }
    
    struct MainNewsData {
        var num: Int!
        var title:String!
        var url:String!
        var date:String!
        var likeCount:Int!
        var disLikeCount:Int!
        var commentCount:Int!
        init(num: Int,title:String,url:String,likeCount:Int,disLikeCount:Int,commentCount:Int,date:String) {
            self.num = num
            self.title = title
            self.url = url
            self.likeCount = likeCount
            self.disLikeCount = disLikeCount
            self.commentCount = commentCount
            self.date = date
        }
    }
    struct RegularResult {
        var questionID:String!
        var QuestionAnswer:String!
        init(questionID:String,QuestionAnswer:String) {
            self.questionID = questionID
            self.QuestionAnswer = QuestionAnswer
        }
    }
    struct UrlData {
        var urlID: String!
        var dateString: String!
        var date:NSDate!
        init(urlID: String,dateString: String,date:NSDate) {
            self.urlID = urlID
            self.dateString = dateString
            self.date = date
        }
    }
}

class Userdata: Object{
    @objc dynamic var name = ""
    @objc dynamic var age  = ""
    @objc dynamic var place  = ""
    @objc dynamic var sex  = ""
    @objc dynamic var userID  = ""
}

class MyLikes: Object {
    @objc dynamic var documentID = ""
}

class MyDisLikes: Object {
    @objc dynamic var documentID = ""
}

class NewsLikes: Object {
    @objc dynamic var documentID = ""
    
}


class NewsDisLikes: Object {
    @objc dynamic var documentID = ""
    
}
class NewsLikes1: Object {
    @objc dynamic var documentID = ""
    @objc dynamic var date  = ""
}


class NewsDisLikes1: Object {
    @objc dynamic var documentID = ""
    @objc dynamic var date  = ""
}
class RegularVote: Object {
    @objc dynamic var flag = false
}

class RegularVoteResult: Object {
    @objc dynamic var questionID = ""
    @objc dynamic var questionTitle = ""
    @objc dynamic var questionAnswer = ""
}

class SNSVote :Object{
    @objc dynamic var snsID = ""
    @objc dynamic var snsDate = Date()
}

class SNSResponse: Object {
    @objc dynamic var snsID = ""
    @objc dynamic var snsDate = Date()
}

class NewsResponse: Object {
    @objc dynamic var newsID = ""
    @objc dynamic var newsDate = Date()
}

class Qusetions{
    var array:[String]!
    var title:String!
    var questionID:String!
    init(array:[String],title:String,questionID:String) {
        self.array = array
        self.title = title
        self.questionID = questionID
    }
}

class ChartResult{
    var title:String!
    var num1:Int!
    var percent:Double
    init(title:String,num1:Int,percent:Double) {
        self.title = title
        self.num1 = num1
        self.percent = percent
    }
}

extension  UIResponder{
    func tabSegue()-> UITabBarController{
        var viewControllers: [UIViewController] = []
        let firstSB = UIStoryboard(name: "Chart", bundle: nil)
        let firstVC = firstSB.instantiateInitialViewController()! as UIViewController
        firstVC.tabBarItem = UITabBarItem(title: "世論調査", image: UIImage(named:"chart"), tag: 1)
        viewControllers.append(firstVC)
        
        // 2ページ目になるViewController
        let secondSB = UIStoryboard(name: "SNS", bundle: nil)
        let secondVC = secondSB.instantiateInitialViewController()! as UIViewController
        secondVC.tabBarItem = UITabBarItem(title: "語り場", image: UIImage(named:"User"), tag: 2)
        viewControllers.append(secondVC)
        
        // 3ページ目になるViewController
        let thirdSB = UIStoryboard(name: "News", bundle: nil)
        let thirdVC = thirdSB.instantiateInitialViewController()! as UIViewController
        thirdVC.tabBarItem = UITabBarItem(title: "ニュース", image: UIImage(named:"news"), tag: 3)
        viewControllers.append(thirdVC)
        
        let fourthSB = UIStoryboard(name: "Setting", bundle: nil)
        let fourthVC = fourthSB.instantiateInitialViewController()! as UIViewController
        fourthVC.tabBarItem = UITabBarItem(title: "設定", image: #imageLiteral(resourceName: "settings"), tag: 4)
        viewControllers.append(fourthVC)
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.unselectedItemTintColor = UIColor.orange
        tabBarController.setViewControllers(viewControllers, animated: false)
        return tabBarController
    }
    func nowDate(num:Int) -> String {
        var date = Date()
        date = date - num.days
        return date.string(custom: "YYYY_MM_dd")
    }
    func shortNowDate(num:Int) -> String {
        var date = Date()
        date = date - num.days
        return date.string(custom: "MM/dd")
    }
}


extension NSDate{
    // NSDate -> Int64
    func toInt64() -> Int64{
        return Int64(timeIntervalSince1970 * 1000)
    }
}

extension Int64{
    // Int64 -> NSDate
    func toNSDate() -> NSDate{
        return NSDate(timeIntervalSince1970: Double(self / 1000) + Double(self % 1000)/1000)
        
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    func cropping(to: CGRect) -> UIImage? {
        var opaque = false
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
            case .noneSkipLast, .noneSkipFirst:
                opaque = true
            default:
                break
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(to.size, opaque, scale)
        draw(at: CGPoint(x: -to.origin.x, y: -to.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
public final class ImageCheckRow<T: Equatable>: Row<ImageCheckCell<T>>, SelectableRowType, RowType {
    public var selectableValue: T?
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class ImageCheckCell<T: Equatable> : Cell<T>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Image for selected state
    lazy public var trueImage: UIImage = {
        return UIImage(named: "selected")!
    }()
    
    /// Image for unselected state
    lazy public var falseImage: UIImage = {
        return UIImage(named: "unselected")!
    }()
    
    public override func update() {
        super.update()
        checkImageView?.image = row.value != nil ? trueImage : falseImage
        checkImageView?.sizeToFit()
    }
    
    /// Image view to render images. If `accessoryType` is set to `checkmark`
    /// will create a new `UIImageView` and set it as `accessoryView`.
    /// Otherwise returns `self.imageView`.
    open var checkImageView: UIImageView? {
        guard accessoryType == .checkmark else {
            return self.imageView
        }
        
        guard let accessoryView = accessoryView else {
            let imageView = UIImageView()
            self.accessoryView = imageView
            return imageView
        }
        
        return accessoryView as? UIImageView
    }
    
    public override func setup() {
        super.setup()
        accessoryType = .none
    }
    
    public override func didSelect() {
        row.reload()
        row.select()
        row.deselect()
    }
    
}
