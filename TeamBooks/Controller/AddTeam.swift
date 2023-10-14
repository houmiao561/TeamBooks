//
//  AddTeam.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/10.
//

import UIKit
import Firebase
import FirebaseAuth

class AddTeam: UIViewController {

    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addTeam(_ sender: UIButton) {
        
        let newMember = self.ref.child("Teams").child(self.teamName.text!).child("TeamMembers")
        let newTeam = self.ref.child("Users").child(self.user!.uid).child("Teams")
        
        ref.child("Teams").observe(.value, with: { (snapshot) in
            for teamSnapshot in snapshot.children {
                if let teamDataSnapshot = teamSnapshot as? DataSnapshot {
                    if self.teamName.text == teamDataSnapshot.key{
                        if let teamDataSnapshot123 = teamDataSnapshot as? DataSnapshot{
                            if let desiredChildSnapshot = teamDataSnapshot.childSnapshot(forPath:"TeamPassword") as? DataSnapshot {
                                
                                if self.teamPassword.text == desiredChildSnapshot.value as? String{
                                    print("!!!!!!!!!!!!!")
                                    
                                    //！！！进来了！！
                                    
                                    newMember.updateChildValues(["Members \(self.user!.uid)":self.user!.email!]) { (error, _) in
                                        if let error = error {
                                            print("Error saving data: \(error.localizedDescription)")
                                        } else {
                                            print("Data successfully saved")
                                        }
                                    }
                                    newTeam.updateChildValues(["Team \(self.teamName.text!)":self.teamName.text!]) { (error, _) in
                                        if let error = error {
                                            print("Error saving data: \(error.localizedDescription)")
                                        } else {
                                            print("Data successfully saved")
                                        }
                                    }
                                      
                                    self.performSegue(withIdentifier: "AddTeamToSelfIntroduce", sender: sender)
                                    
                                    
                                    
                                }else{
                                    print("?????????????")
                                }
                            }
                        }else{print("if let teamDataSnapshot123 = teamDataSnapshot as? DataSnapshot")}
                    }else{
                        print("if self.teamName.text == teamDataSnapshot.key WRONG")
                        
                    }
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTeamToSelfIntroduce" {
            if let destinationVC = segue.destination as? SelfIntroduce {
                //print("teamName.text\(teamName.text)")
                destinationVC.teamName123 = teamName.text!
                destinationVC.oneselfUID123 = user!.uid
            }
        }
    }
}
