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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downlodarTextFromFirebase()
        downloadImageFromFirebaseStorage()
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
            } else if let error = error {
                // 处理获取下载 URL 的错误
                print("Error getting download URL: \(error.localizedDescription)")
            }
        }
        
    }
    
    func downlodarTextFromFirebase(){
        ref = Database.database().reference().child("Teams").child("\(nameFormMYTEAMS)")
        ref.observe(.value, with: { (snapshot) in
            
            if let teamDetailData = snapshot.value as? [String: Any] {
                for (key, value) in teamDetailData{
                    
                    switch key{
                    case "TeamName": self.teamName.text = value as? String
                    case "TeamDate": self.teamDate.text = value as? String
                    case "TeamIntroduce":self.teamIntroduce.text = value as? String
                    case "TeamPassword":self.teamPassword.text = value as? String
                    default:print("switch WRONG")
                    }
                    
                }
            }
        })
    }

}
