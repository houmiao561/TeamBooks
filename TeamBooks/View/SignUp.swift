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
import NVActivityIndicatorView

class SignUp: UIViewController {//创建账号时就包括了登录
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    private let realtimeRef = Database.database().reference()
    private let firestoreRef = Firestore.firestore().collection("UserAccont")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建加载动画视图，选择适合您应用的样式、颜色和大小
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        // 将加载动画视图添加到父视图中并居中
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }
    
    @IBAction func SignUp(_ sender: Any) {
        activityIndicatorView.startAnimating()
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) {(authResult, error) in
            if let _ = error {//登录失败弹窗
                let alertController = UIAlertController(title: "Something Wrong !", message: "1.Plz enter your right email.\n2.The password must be 6 string long or more.\n3.Maybe this Email Account has been Sign Up?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.activityIndicatorView.stopAnimating()
                self.present(alertController,animated: true,completion: nil)
                
            } else {//登录成功保存到firebase
                self.activityIndicatorView.stopAnimating()
                if let user = authResult?.user {
                    self.realtimeRef.child("Users").child("\(user.uid)").setValue(
                        ["UserUID":user.uid,
                         "UserEmail":user.email])
                }
                
                let alertController = UIAlertController(title: "Great!", message: "Sign Up and Log In Succeed.", preferredStyle: .alert)
                // 显示 UIAlertController
                self.present(alertController, animated: true, completion: nil)
                
                // 延时两秒后自动关闭 UIAlertController
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alertController.dismiss(animated: true, completion: nil)
                    self.navigationController!.popToRootViewController(animated: true)
                }
                
                
                
                
            }
        }
        
    }
    
    
    
    
}
