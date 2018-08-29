//
//  TagTableViewCell.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/17.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

   
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "TagCollectionViewCell", bundle: nil) // カスタムセルクラス名で`nib`を作成する
        tagCollectionView.register(nib, forCellWithReuseIdentifier: "TagCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width)/3
        layout.itemSize = CGSize(width: Double(width), height: 20.0)
        layout.minimumInteritemSpacing = 5
        tagCollectionView.collectionViewLayout = layout
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int){
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        let width1 = (UIScreen.main.bounds.size.width - CGFloat(30))/3
        layout.itemSize = CGSize(width: width1, height: 30)
        tagCollectionView.delegate = dataSourceDelegate
        tagCollectionView.dataSource = dataSourceDelegate
        tagCollectionView.collectionViewLayout = layout
        tagCollectionView.reloadData()
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
