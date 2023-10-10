//
//  AddTeam.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/10.
//

import UIKit
import Firebase

class AddTeam: UIViewController {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    
    let ref = Database.database().reference().child("Teams")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addTeam(_ sender: UIButton) {
        ref.observe(.value, with: { (snapshot) in
            for teamSnapshot in snapshot.children {
                if let teamDataSnapshot = teamSnapshot as? DataSnapshot {
                    let teamKey = teamDataSnapshot.key
                    if self.teamName.text == teamKey{
                        print("Team Key: \(teamKey)")
                        for teamChildSnapshot in teamDataSnapshot.children {
                                if let teamChildDataSnapshot = teamChildSnapshot as? DataSnapshot {
                                    // 获取子项的键和值
                                    let teamChildKey = teamChildDataSnapshot.key
                                    let teamChildValue = teamChildDataSnapshot.value
                                    print("Key: \(teamChildKey), Value: \(teamChildValue!)")
                                }
                            }
                    }else{
                        print("Team Key WRONG")
                    }
                }
            }
        })
    }
}
