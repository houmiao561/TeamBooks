//
//  AddTeam.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class CreatTeam: UIViewController {
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var teamDate: UITextField!
    @IBOutlet weak var teamPassword: UITextField!
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var teamIntroduce: UITextField!
    
    private let ref = Database.database().reference()
    private let storageRef = Storage.storage().reference()
    private let user = Auth.auth().currentUser
    var activityIndicatorView: NVActivityIndicatorView!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //注册点击图片手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        teamLogo.addGestureRecognizer(tapGestureRecognizer)
        teamLogo.isUserInteractionEnabled = true
        teamLogo.contentMode = .scaleAspectFill
        teamLogo.layer.cornerRadius = 5.0
        teamLogo.layer.masksToBounds = true
        
        
        
        //注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }

    @IBAction func addTeamButton(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        //只在图片上传成功后 加载动画显示结束即可 文字上传不用管
        uploadImageToFirebase(image: teamLogo.image!)
        uploadTextToFirebase()
    }
}






//MARK: -PictureSelect Gesture
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
        if let imageData = image.jpegData(compressionQuality: 0.0001) {
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                self.activityIndicatorView.stopAnimating()
                let alertController = UIAlertController(title: "Great!", message: "Creat Team Succeed.", preferredStyle: .alert)
                // 显示 UIAlertController
                self.present(alertController, animated: true, completion: nil)
                // 延时两秒后自动关闭 UIAlertController
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alertController.dismiss(animated: true, completion: nil)
                    self.navigationController!.popViewController(animated: true)
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

