//
//  SignUp.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/5.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseStorage

class SignUp: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private let realtimeRef = Database.database().reference()
    private let firestoreRef = Firestore.firestore().collection("UserAccont")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) {(authResult, error) in
            if let _ = error {//登录失败弹窗
                let alertController = UIAlertController(title: "Something Wrong !", message: "1.Plz enter your right email.\n2.The password must be 6 string long or more.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {//登录成功保存到firebase
                if let user = authResult?.user {
                    self.realtimeRef.child("Users").child("\(user.uid)").setValue(
                        ["UserUID":user.uid,
                         "UserEmail":user.email])//保存到realtime,但是无法保存特殊字符
                }
            }
        }
        
        self.navigationController!.popViewController(animated: true)
        
    }
    
    
    
    
}
