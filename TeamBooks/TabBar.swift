//
//  TabBar.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase

class TabBar: UITabBarController {

    var teamName = ""
    var teamDate = ""
    var teamIntroduce = ""
    var teamPassword = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("43917572649358\(teamName)")
        ref = Database.database().reference().child("Teams").child(teamName)
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for teamSnapshot in teamsSnapshot {
                    if let teamName = teamSnapshot.childSnapshot(forPath: "teamName").value as? String,
                       let teamIntroduce = teamSnapshot.childSnapshot(forPath: "teamIntroduce").value as? String,
                       let teamPassword = teamSnapshot.childSnapshot(forPath: "teamPassword").value as? String,
                       let teamDate = teamSnapshot.childSnapshot(forPath: "teamDate").value as? String{
                        self.teamDate = teamDate
                        self.teamName = teamName
                        self.teamPassword = teamPassword
                        self.teamIntroduce = teamIntroduce
                    }
                    
                    
                    print(teamSnapshot)
                    
                    
                }
            } else {print("123.")}
        })
    }

}
