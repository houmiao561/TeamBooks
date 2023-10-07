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
                    //保存到realtime，但是(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']'，
//                    if let UserEmail = self.email.text as? NSString,
//                       let UserPassword = self.password.text as? NSString{
                        
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        ref.child("Users").child("\(user.uid)").setValue(["UserUID":user.uid])
//                    }
                    
                    //保存到firestore
                    let collectionRef = db.collection("UserAccont")
                    collectionRef.addDocument(data: ["emali":self.email.text!,"password":self.password.text!,"Uid":user.uid])
                }
            }
        }
        
        self.navigationController!.popViewController(animated: true)
        
    }
    
    
    
    
}
