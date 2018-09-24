//
//  VoteListViewController.swift
//  Politics
//
//  Created by tatsumi kentaro on 2018/08/09.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
class VoteListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    let db = Firestore.firestore()
    var questionArray = [Qusetions]()
    var num: Int!
    @IBOutlet weak var mainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTable.dataSource = self
        mainTable.delegate  = self
        db.collection("questions").getDocuments { (snap, error) in
            for content in snap!.documents{
                let data = content.data()
                //                print(data)
                self.questionArray.append(Qusetions(array: data["question_array"] as! [String], title: data["main_title"] as! String, questionID: content.documentID))
            }
            self.mainTable.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = questionArray[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        performSegue(withIdentifier: "GoVote", sender: nil)
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoVote"{
            let voteviewController = segue.destination as! VoteViewController
            voteviewController.questions = self.questionArray[num]
        }
    }
    

}
