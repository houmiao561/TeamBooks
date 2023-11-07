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
    @IBOutlet weak var teamPassword: UILabel!
    @IBOutlet weak var TeamLogo: UIImageView!
    @IBOutlet weak var teamIntroduce: UITextView!
    
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    var nameFormMYTEAMS = ""    //点击MyTeams中的任意一个之后，传过来的TeamName
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //执行函数
        downlodarTextFromFirebase()
        downloadImageFromFirebaseStorage()
        
        
        //照片修饰框架
        TeamLogo.contentMode = .scaleAspectFill
        TeamLogo.layer.cornerRadius = 10.0 // 设置圆角半径
        TeamLogo.layer.masksToBounds = true // 剪切超出圆角范围的内容
        TeamLogo.layer.borderWidth = 0.3 // 边框的粗细
        TeamLogo.layer.borderColor = UIColor.lightGray.cgColor // 边框的颜色
    }
    
}







//MARK: -Firebase
extension TeamDetail{
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
                print(error)
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
