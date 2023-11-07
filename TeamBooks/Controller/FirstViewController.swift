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
    }

    @IBAction func LetsGoButton(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if user != nil{
            performSegue(withIdentifier: "FirstToMyTeam", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }
    }
    
    @IBAction func AccountSetting(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        if user == nil{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
        }else{
            performSegue(withIdentifier: "FirstToAccountDetail", sender: sender)
        }
    }
}
