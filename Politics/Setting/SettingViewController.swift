//
//  SettingViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/09/15.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase
import Nuke
import FirebaseStorageUI
class SettingViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var mainTable: UITableView!
    let sectionArray = ["あなたの登録情報","投票関連","あなたの投稿関連","ニュース関連"]
    let realm = try! Realm()
    
    var image:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTable.delegate = self
        mainTable.dataSource = self
        self.mainTable.register(UINib(nibName: "ProfileSettingTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingTableViewCell")
        self.mainTable.register(UINib(nibName: "ProfileEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileEditTableViewCell")
        self.mainTable.register(UINib(nibName: "ProfileDetailEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileDetailEditTableViewCell")

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension SettingViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSettingTableViewCell", for: indexPath) as! ProfileSettingTableViewCell
                let user = realm.objects(Userdata.self)[0]
                cell.nameLabel.text = user.name
                cell.sexLabel.text = user.sex
                cell.placeLabel.text = user.place
                cell.ageLabel.text = user.age
//                if image != nil{
//                    cell.profileImage.image = image
//                }
               
                let storageRef = Storage.storage().reference()
                let reference = storageRef.child("image/profile/\(user.userID).jpg")
                
                cell.profileImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "placeholder"))
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell", for: indexPath) as! ProfileEditTableViewCell
                cell.editBtn.addTarget(self, action: #selector(self.cameraTap(sender:)), for: .touchUpInside)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailEditTableViewCell", for: indexPath) as! ProfileDetailEditTableViewCell
                cell.editBtn.addTarget(self, action: #selector(self.editTap(sender:)), for: .touchUpInside)
                return cell

            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditTableViewCell", for: indexPath)
            
            return cell
        }
    }
    @objc func editTap(sender:UIButton){
        performSegue(withIdentifier: "Edit", sender: nil)
    }
    @objc func cameraTap(sender:UIButton){
        let alert: UIAlertController = UIAlertController(title: "どちらか選択して下さい", message: "カメラをかフォトライブラリーかを選択して下さい？", preferredStyle:  UIAlertControllerStyle.actionSheet)
        let defaultCameraAction: UIAlertAction = UIAlertAction(title: "カメラを起動する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("Camera")
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                
                self.present(picker, animated: true, completion: nil)
            }else{
                self.alert(message: "error")
            }
        })
        let defaultLibralyAction: UIAlertAction = UIAlertAction(title: "フォトライブラリーを起動する", style: UIAlertActionStyle.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("Libraly")
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                
                self.present(picker, animated: true, completion: nil)
            }else{
                self.alert(message: "error")
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancel")
        })
        alert.addAction(defaultCameraAction)
        alert.addAction(defaultLibralyAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.orange
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            if indexPath.row == 1{

            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        image = info[UIImagePickerControllerEditedImage] as! UIImage
        image = image.resize(size: CGSize(width: 200, height: 200))
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data: Data = UIImageJPEGRepresentation(image!, 0.2)!
        let user = realm.objects(Userdata.self)[0]
        let imagePath = storageRef.child("image").child("profile").child("\(user.userID).jpg")
        imagePath.putData(data, metadata: nil) { (metadata, error) in
            
            if let error = error{
                self.alert(message: error.localizedDescription)
            }else{
                
                SDImageCache.shared().clearMemory()
                SDImageCache.shared().clearDisk()
                self.mainTable.reloadData()
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
