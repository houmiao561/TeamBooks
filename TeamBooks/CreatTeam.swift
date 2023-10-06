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
    
    private let imagePicker = UIImagePickerController()
    private let user = Auth.auth().currentUser
    private var teamDetailText = TeamDetailText(
        name: "Team Name",
        date: "2023-10-06",
        password: "secure_password",
        introduce: "This is our team.",
        members: ["Member 1", "Member 2"],
        logo: UIImage(named: "team_logo") ?? UIImage()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        teamLogo.addGestureRecognizer(tapGestureRecognizer)
        teamLogo.isUserInteractionEnabled = true
        
    }

    @IBAction func addTeamButton(_ sender: UIButton) {
        uploadTextToFirebase()
        dismiss(animated: true)
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
        picker.dismiss(animated: true, completion: nil)
        uploadImageToFirebase(image: teamLogo.image!)
    }

}







//MARK: -Firebase
extension CreatTeam{
    
    func uploadImageToFirebase(image: UIImage) {
        // 获取 Firebase 存储的引用
        let storageRef = Storage.storage().reference()
        // 获取对应的存储位置的引用
        let imageRef = storageRef.child("ProfilePhoto/\(user!.email!)")
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
        // 开始上传图片
        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    print("SucceedLoadUpPhoto!!!!")
                }
            }
        }
    }
    
    func uploadTextToFirebase(){
        teamDetailText.name = teamName.text!
        teamDetailText.date = teamDate.text!
        teamDetailText.password = teamPassword.text!
        teamDetailText.members = [String((user!.email)!)]
        teamDetailText.introduce = teamIntroduce.text!
        let collectionRef = db.collection("TeamDetail") // 替换为您的集合名称
        collectionRef.addDocument(data:["name":teamDetailText.name,
                                        "date": teamDetailText.date,
                                        "password": teamDetailText.password,
                                        "members":teamDetailText.members,
                                        "introduce":teamDetailText.introduce])
    }
}








