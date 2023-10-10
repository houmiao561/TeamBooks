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
        downlodarTextFromFirebase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for teamSnapshot in teamsSnapshot {
                    if let teamName = teamSnapshot.childSnapshot(forPath: "TeamName").value as? String,
                       let teamIntroduce = teamSnapshot.childSnapshot(forPath: "TeamIntroduce").value as? String,
                       let teamPassword = teamSnapshot.childSnapshot(forPath: "TeamPassword").value as? String,
                       let teamDate = teamSnapshot.childSnapshot(forPath: "TeamDate").value as? String{
                        self.teamDate.text = teamDate; self.teamName.text = teamName; self.teamPassword.text = teamPassword; self.teamIntroduce.text = teamIntroduce
                    }else{print("INTER for teamSnapshot in teamsSnapshot ERROR!!")}
                }
            } else {print("ENTER if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] ERROR")}
        })
    }

}
