//
//  TeamDetail.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase

class TeamDetail: UIViewController {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamDate: UILabel!
    @IBOutlet weak var teamIntroduce: UILabel!
    @IBOutlet weak var teamPassword: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for teamSnapshot in teamsSnapshot {
                    if let teamName = teamSnapshot.childSnapshot(forPath: "TeamName").value as? String,
                       let teamIntroduce = teamSnapshot.childSnapshot(forPath: "TeamIntroduce").value as? String,
                       let teamPassword = teamSnapshot.childSnapshot(forPath: "TeamPassword").value as? String,
                       let teamDate = teamSnapshot.childSnapshot(forPath: "TeamDate").value as? String{
                        self.teamDate.text = teamDate; self.teamName.text = teamName; self.teamPassword.text = teamPassword; self.teamIntroduce.text = teamIntroduce
                    }else{print("INTER for teamSnapshot in teamsSnapshot ERROR!!")}
                }
            } else {print("ENTER if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] ERROR")}
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 

}
