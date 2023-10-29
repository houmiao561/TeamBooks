//
//  FirstViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseAuth
class FirstViewController: UIViewController {
    
    @IBOutlet weak var teamBooks: UILabel!
    var user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamBooks.text = ""
        var charIndex = 0.0
        let titleText = "TeamBooks"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { timer in
                self.teamBooks.text?.append(letter) //闭包要加self
            }
            charIndex += 1
        }
        if let user = Auth.auth().currentUser {
            user.reload { (error) in
                if let error = error {
                    print("Error reloading user: \(error.localizedDescription)")
                } else {
                    print("User reloaded successfully")
            
                    if user.isEmailVerified {
                        print("User's email is verified")
                    } else {
                        print("User's email is not verified")
                    }
                }
            }
        } else {
            print("No user is currently signed in.")
        }
    }

    @IBAction func LetsGoButton(_ sender: UIButton) {
        if user != nil{
            performSegue(withIdentifier: "FirstToMyTeam", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }
    }
    
    @IBAction func AccountSetting(_ sender: UIButton) {
        if user == nil{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToAccountDetail", sender: sender)
        }
    }
}
