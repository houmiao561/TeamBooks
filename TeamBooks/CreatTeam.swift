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
        
        //点击手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        teamLogo.addGestureRecognizer(tapGestureRecognizer)
        teamLogo.isUserInteractionEnabled = true
        
        //下滑手势
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        swipeDownGestureRecognizer.delegate = self
        
        //上划手势
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeUpGestureRecognizer.direction = .up
        view.addGestureRecognizer(swipeUpGestureRecognizer)
        swipeUpGestureRecognizer.delegate = self
        
    }

    @IBAction func addTeamButton(_ sender: UIButton) {
        uploadTextToFirebase()
        uploadImageToFirebase(image: teamLogo.image!)
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
        picker.dismiss(animated: true)
    }

}







//MARK: -Firebase
extension CreatTeam{
    
    func uploadImageToFirebase(image: UIImage) {
        let imageRef = storageRef.child("TeamLogo").child("\(teamName.text!)")
        if let imageData = image.jpegData(compressionQuality: 1.0) {
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
        if let teamNameText = self.teamName.text as? NSString,
           let teamIntroduceText = self.teamIntroduce.text as? NSString,
           let teamPassword = self.teamPassword.text as? NSString,
           let teamDate = self.teamDate.text as? NSString{
            ref.child("Teams").child("\(teamNameText)").setValue(["TeamName":teamNameText,
                                                                  "TeamIntroduce":teamIntroduceText,
                                                                  "TeamPassword": teamPassword,
                                                                  "TeamDate": teamDate
                                                                 ])
        }
    }
}








//MARK: -Gesture
extension CreatTeam: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }//与其他手势协同工作
    
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .down{
            view.resignFirstResponder()
        }
        if gestureRecognizer.direction == .up{
            view.resignFirstResponder()
        }
    }
    
}







