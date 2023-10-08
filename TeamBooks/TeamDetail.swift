//
//  TeamDetail.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase

class TeamDetail: UIViewController {
    @IBOutlet weak var teamName: UILabel!
//    @IBOutlet weak var teamDate: UILabel!
//    @IBOutlet weak var teamIntro: UILabel!
    @IBOutlet weak var teamPassword: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = self.tabBarController as? TabBar {
//            teamName.text = tabBarController.teamName
//            teamDate.text = tabBarController.teamDate
//            teamIntro.text = tabBarController.teamIntroduce
            teamPassword.text = tabBarController.teamPassword
        }
    }
 

}
