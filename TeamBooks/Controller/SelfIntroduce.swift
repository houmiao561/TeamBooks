//
//  SelfIntroduce.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/14.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import NVActivityIndicatorView

class SelfIntroduce: UIViewController {
    
    @IBOutlet weak var selfPhotp: UIImageView!
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var oneselfIntroduce: UITextField!
    @IBOutlet weak var oneselfJob: UITextField!
    @IBOutlet weak var oneselfBirthday: UITextField!
    @IBOutlet weak var oneselfName: UITextField!
    
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser!
    let storageRef = Storage.storage().reference()
    private let imagePicker = UIImagePickerController()
    var activityIndicatorView: NVActivityIndicatorView!
    
    var teamName123 = ""    //teamName
    var oneselfUID123 = ""  //UID
    var sendMessage = ["":""]   //自我介绍时需要添加的信息
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //注册手势信息
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selfPhotp.addGestureRecognizer(tapGestureRecognizer)
        selfPhotp.isUserInteractionEnabled = true
        
        
        
        //注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        
        
        
        //执行函数
        teamName.text = teamName123
    }
    
    @IBAction func add(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        sendMessage = ["teamName":teamName.text!,
                       "oneselfEmail":String(user.email!),
                       "oneselfUID":oneselfUID123,
                       "oneselfIntroduce":oneselfIntroduce.text!,
                       "oneselfJob":oneselfJob.text!,
                       "oneselfBirthday":oneselfBirthday.text!,
                       "oneselfName":oneselfName.text!]
        
        ref.child("OneselfIntroduceInTeam").child("\(teamName.text!)").child("Members \(user.uid)").updateChildValues(sendMessage) { (error, _) in
            if let error = error {
                print("Error saving data: \(error.localizedDescription)")
                self.activityIndicatorView.stopAnimating()
            } else {
                if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if viewController is MyTeams {
                            self.navigationController?.popToViewController(viewController, animated: true)
                            break
                        }
                    }
                }
            }
        }
        uploadImageToFirebaseStorage(image: self.selfPhotp.image!)
    }
    
}








//MARK: -Firebase
extension SelfIntroduce{
    func uploadImageToFirebaseStorage(image: UIImage) {
        let imageRef = storageRef.child("UserIntroducePhoto").child("\(teamName123)").child("Members \(user.uid)")
        if let imageData = image.jpegData(compressionQuality: 0.0001) {
            // 开始上传图片
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    self.activityIndicatorView.stopAnimating()
                    self.dismiss(animated: true)
                }
            }
        }
    }
}








//MARK: -Gesture
extension SelfIntroduce:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imageTapped() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selfPhotp.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
