//
//  FirstViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func LetsGoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToTabBar", sender: sender)
    }
    @IBAction func AccountSetting(_ sender: UIButton) {
        performSegue(withIdentifier: "FirstToAccount", sender: sender)
    }
}
