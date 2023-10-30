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
    }

    @IBAction func LetsGoButton(_ sender: UIButton) {
        var user = Auth.auth().currentUser
        if user != nil{
            performSegue(withIdentifier: "FirstToMyTeam", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }
    }
    
    @IBAction func AccountSetting(_ sender: UIButton) {
        var user = Auth.auth().currentUser
        if user == nil{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToAccountDetail", sender: sender)
        }
    }
}
