//
//  SelfIntroduce.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/14.
//

import UIKit

class SelfIntroduce: UIViewController {

    var teamName123 = ""
    var oneselfUID123 = ""
    
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var oneselfUID: UITextField!
    
    @IBOutlet weak var oneselfIntroduce: UITextField!
    
    @IBOutlet weak var oneselfJob: UITextField!
    
    @IBOutlet weak var oneselfBirthday: UITextField!
    
    @IBOutlet weak var oneselfName: UITextField!
    
    @IBOutlet weak var oneselfGesture: UITextField!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamName.text = teamName123
        oneselfUID.text = oneselfUID123
    }
    
    

}
