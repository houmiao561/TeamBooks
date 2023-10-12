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
                    if self.teamName.text == teamDataSnapshot.key{
                        if let teamDataSnapshot123 = teamDataSnapshot as? DataSnapshot{
                            if let desiredChildSnapshot = teamDataSnapshot.childSnapshot(forPath:"TeamPassword") as? DataSnapshot {
                                
                                /* TEST !!
                                print("desiredChildSnapshot: \(desiredChildSnapshot)")
                                print("desiredChildSnapshot.key: \(qwe)")
                                print("desiredChildSnapshot.value: \(asd)")
                                 */
                                
                                let qwe = desiredChildSnapshot.key
                                let asd = desiredChildSnapshot.value as! String
                                if self.teamPassword.text == asd{
                                    print("!!!!!!!!!!!!!")
                                    
                                    
                                }else{
                                    print("?????????????")
                                }
                                
                                
                                
                                
                            }
                        }//else{print("if let teamDataSnapshot123 = teamDataSnapshot as? DataSnapshot")}
                    }//else{print("if self.teamName.text == teamDataSnapshot.key WRONG")}
                }
            }
        })
    }
}
