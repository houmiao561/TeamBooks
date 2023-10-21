//
//  AccountSettingViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage


class LogIn: UIViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "LogInToSignUp", sender: sender)
    }
    
    
    @IBAction func LogIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "Plz check your email and password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else { }
        }
        self.navigationController!.popToRootViewController(animated: true)
    }
    
}
