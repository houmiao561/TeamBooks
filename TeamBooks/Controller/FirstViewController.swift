//
//  FirstViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseAuth
class FirstViewController: UIViewController {
    
    private let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func LetsGoButton(_ sender: UIButton) {
        if user != nil{
            performSegue(withIdentifier: "FirstToMyTeam", sender: sender)
        }else{
            let alertController = UIAlertController(title: "Something Wrong !", message: "Please Log In", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true,completion: nil)
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
