//
//  MyTeams.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit

class MyTeams: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func CreatTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
    @IBAction func b(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToTabBar", sender: sender)
    }
}
