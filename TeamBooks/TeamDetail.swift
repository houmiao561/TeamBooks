//
//  TeamDetail.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
import FirebaseStorage

class TeamDetail: UIViewController {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamDate: UILabel!
    @IBOutlet weak var teamIntroduce: UILabel!
    @IBOutlet weak var teamPassword: UILabel!
    @IBOutlet weak var TeamLogo: UIImageView!
    
    var ref: DatabaseReference!
    var nameFormMYTEAMS = ""
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downlodarTextFromFirebase()
        downloadImageFromFirebaseStorage()
        
        TeamLogo.contentMode = .scaleAspectFill
        TeamLogo.layer.cornerRadius = 10.0 // 设置圆角半径
        TeamLogo.layer.masksToBounds = true // 剪切超出圆角范围的内容
    }
 
    
    func downloadImageFromFirebaseStorage(){
        let imageRef = storageRef.child("TeamLogo/").child("\(nameFormMYTEAMS)")
        
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.TeamLogo.image = image
                        }
                    }
                }
            } else if let _ = error {
                
            }
        }
        
    }
    
    func downlodarTextFromFirebase(){
        ref = Database.database().reference().child("Teams").child("\(nameFormMYTEAMS)")
        ref.observe(.value, with: { (snapshot) in
            
            if let teamDetailData = snapshot.value as? [String: Any] {
                for (key, value) in teamDetailData{
                    
                    switch key{
                    case "TeamName": self.teamName.text = "Team Name: " + (value as? String)!
                    case "TeamDate": self.teamDate.text = "Team Birthday: " + (value as? String)!
                    case "TeamIntroduce":self.teamIntroduce.text = "Team Introduce: " + (value as? String)!
                    case "TeamPassword":self.teamPassword.text = "Team Enter Password: " + (value as? String)!
                    default: break
                    }
                    
                }
            }
        })
    }

}
