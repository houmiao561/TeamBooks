//
//  FirstViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class FirstViewController: UIViewController {
    
    @IBOutlet weak var teamBooks: UILabel!
    
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
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
        activityIndicatorView.startAnimating()
        let user = Auth.auth().currentUser
        if user == nil{
            performSegue(withIdentifier: "FirstToLogIn", sender: sender)
            activityIndicatorView.stopAnimating()
        }else{
            performSegue(withIdentifier: "FirstToAccountDetail", sender: sender)
            activityIndicatorView.stopAnimating()
        }
    }
}
