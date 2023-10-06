//
//  SignUp.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/5.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseStorage

class SignUp: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private var userAccountText = UserAccountText(email: "", password: "", Uid: "")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func SignUp(_ sender: Any) {
        
        userAccountText.email = email.text!
        userAccountText.password = password.text!
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) {(authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "1.Plz enter your right email.\n2.The password must be 6 string long or more.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {
                if let user = authResult?.user {
                    let uid = user.uid
                    print("新用户的 UID：\(uid)")
//                    self.userAccountText.Uid = uid
                    let collectionRef = db.collection("UserAccont") // 替换为您的集合名称
                    collectionRef.addDocument(data: ["emali":self.email.text,"password":self.password.text,"Uid":uid])
                }
            }
        }
        
        
        
        self.navigationController!.popViewController(animated: true)

    }
    
    
    
    
}
