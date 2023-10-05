//
//  AddTeam.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class CreatTeam: UIViewController {
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamDate: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    @IBOutlet weak var teamLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addTeamButton(_ sender: UIButton) {
        
    }
}
