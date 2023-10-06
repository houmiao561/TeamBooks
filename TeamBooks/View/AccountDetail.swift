//
//  AccountDetail.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/6.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class AccountDetail: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var currentUID: UITextField!
    
    private let user = Auth.auth().currentUser!
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImageFromFirebaseStorage()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.isUserInteractionEnabled = true
        
        photo.layer.cornerRadius = photo.frame.size.width / 2.0
        photo.layer.masksToBounds = true // 剪切超出圆角范围的内容
        photo.contentMode = .scaleAspectFill
        
        currentUID.text = String(user.uid)
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            print("用户已注销")
        } catch let signOutError as NSError {
            print("注销出错：\(signOutError.localizedDescription)")
        }
    }
    
}


extension AccountDetail:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func imageTapped() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            photo.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
//        uploadImageToFirebaseStorage(image: photo.image!)
    }
    
}






//MARK: -Firebase Photo
extension AccountDetail{
    
    func uploadImageToFirebaseStorage(image: UIImage) {
        // 获取 Firebase 存储的引用
        let storageRef = Storage.storage().reference()
        // 获取对应的存储位置的引用
        let imageRef = storageRef.child("ProfilePhoto/\(user.email!)")
        
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
    
    
    func downloadImageFromFirebaseStorage(){
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("ProfilePhoto/\(user.email!)")
        
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.photo.image = image
                        }
                    }
                }
            } else if let error = error {
                // 处理获取下载 URL 的错误
                print("Error getting download URL: \(error.localizedDescription)")
            }
        }
        
    }
}
