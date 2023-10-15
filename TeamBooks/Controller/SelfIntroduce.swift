//
//  SelfIntroduce.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/14.
//

import UIKit
import Firebase
import FirebaseAuth

class SelfIntroduce: UIViewController {

    var teamName123 = ""
    var oneselfUID123 = ""
    let ref = Database.database().reference()
    var sendMessage = ["":""]
    let user = Auth.auth().currentUser!
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var oneselfUID: UITextField!
    
    @IBOutlet weak var oneselfIntroduce: UITextField!
    @IBOutlet weak var oneselfJob: UITextField!
    @IBOutlet weak var oneselfBirthday: UITextField!
    @IBOutlet weak var oneselfName: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamName.text = teamName123
        oneselfUID.text = oneselfUID123
    }
    
    @IBAction func add(_ sender: UIButton) {
        sendMessage = ["teamName":teamName.text!,
                           "oneselfUID":oneselfUID.text!,
                           "oneselfIntroduce":oneselfIntroduce.text!,
                           "oneselfJob":oneselfJob.text!,
                           "oneselfBirthday":oneselfBirthday.text!,
                           "oneselfName":oneselfName.text!]
        
        ref.child("OneselfIntroduceInTeam").child("\(teamName.text!)").child("Members \(user.uid)").updateChildValues(sendMessage) { (error, _) in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
                
            } else {
                print("Data successfully saved")
                self.dismiss(animated: true)
            }
        }
        
    }
    

}
