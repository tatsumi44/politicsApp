//
//  PublicVoteListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2019/01/31.
//  Copyright © 2019 tatsumi kentaro. All rights reserved.
//

import UIKit

class PublicVoteListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.delegate = self
        mainTable.dataSource = self
        self.mainTable.register(UINib(nibName: "publicVoteListTableViewCell", bundle: nil), forCellReuseIdentifier: "publicVoteListTableViewCell")
        // Do any additional setup after loading the view.
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicVoteListTableViewCell") as! publicVoteListTableViewCell
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
