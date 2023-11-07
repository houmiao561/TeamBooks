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
import NVActivityIndicatorView

class LogIn: UIViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "LogInToSignUp", sender: sender)
    }
    
    
    @IBAction func LogIn(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if let _ = error {//失败弹窗
                let alertController = UIAlertController(title: "Something Wrong!", message: "Plz check your email and password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.activityIndicatorView.stopAnimating()
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.activityIndicatorView.stopAnimating()
                let alertController = UIAlertController(title: "Great!", message: "Log In Succeed.", preferredStyle: .alert)
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
