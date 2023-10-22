//
//  AddTeam.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
import FirebaseAuth

class CreatTeam: UIViewController {
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamDate: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamIntroduce: UITextField!
    
    private let ref = Database.database().reference()
    private let storageRef = Storage.storage().reference()
    private let imagePicker = UIImagePickerController()
    private let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        teamLogo.addGestureRecognizer(tapGestureRecognizer)
        teamLogo.isUserInteractionEnabled = true
        teamLogo.contentMode = .scaleAspectFill
        teamLogo.layer.cornerRadius = 5.0
        teamLogo.layer.masksToBounds = true
    }

    @IBAction func addTeamButton(_ sender: UIButton) {
        uploadImageToFirebase(image: teamLogo.image!)
        uploadTextToFirebase()
    }
}






//MARK: -PictureSelect
extension CreatTeam:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imageTapped() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            teamLogo.image = selectedImage
        }
        picker.dismiss(animated: true)
    }

}







//MARK: -Firebase
extension CreatTeam{
    
    func uploadImageToFirebase(image: UIImage) {
        let imageRef = storageRef.child("TeamLogo").child("\(teamName.text!)")
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let _ = error {
                    
                }
            }
        }
    }
    
    
    func uploadTextToFirebase() {
        if teamName.text != "" && teamDate.text != "" && teamPassword.text != "" && teamIntroduce.text != ""{
            if let teamNameText = self.teamName.text,
               let teamIntroduceText = self.teamIntroduce.text,
               let teamPassword = self.teamPassword.text,
               let teamDate = self.teamDate.text{
                let sendTeamMessage = ["TeamName": teamNameText,
                                       "TeamIntroduce": teamIntroduceText,
                                       "TeamPassword": teamPassword,
                                       "TeamDate": teamDate] as [String : Any]
                ref.child("Teams").child("\(teamNameText)").observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.exists() {
                        let alertController = UIAlertController(title: "Something Wrong !", message: "Team Name has been occupied", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController,animated: true,completion: nil)
                    } else {
                        if self.teamName.text != nil{
                            self.ref.child("Teams").child("\(teamNameText)").setValue(sendTeamMessage) { (error, _) in
                                if let _ = error {
                                    
                                }else{
                                    self.dismiss(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }else{
            let alertController = UIAlertController(title: "Please add all info", message: "Some info hasn't been added!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController,animated: true,completion: nil)
        }
    }
}

