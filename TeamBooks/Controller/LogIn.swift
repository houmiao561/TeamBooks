//
//  AccountSettingViewController.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage


class LogIn: UIViewController{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var profilePhoto: UILabel!
    
    let imagePicker = UIImagePickerController()
    private let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.isUserInteractionEnabled = true
        downloadImageFromFirebaseStorage()
        
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "LogInToSignUp", sender: sender)
    }
    
    @IBAction func LogIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if let _ = error {
                let alertController = UIAlertController(title: "Something Wrong !", message: "Plz check your email and password.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController,animated: true,completion: nil)
            } else {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
    
}



extension LogIn:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        uploadImageToFirebaseStorage(image: photo.image!)
    }

}






//MARK: -Firebase Photo
extension LogIn{

    func uploadImageToFirebaseStorage(image: UIImage) {
        // 获取 Firebase 存储的引用
        let storageRef = Storage.storage().reference()
        
        // 创建一个唯一的文件名，以避免文件名冲突
        let uniqueImageName = "ProfilePhoto/image_\(user!.email!).jpg"
        
        // 获取对应的存储位置的引用
        let imageRef = storageRef.child(uniqueImageName)
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            // 开始上传图片
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    // 处理上传错误
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    // 上传成功，可以从 metadata 中获取文件的下载 URL
                    imageRef.downloadURL { (url, error) in
                        if let downloadURL = url {
                            // 在这里，您可以使用 downloadURL，例如将其保存到数据库中或显示在应用程序中
                            print("Image download URL: \(downloadURL)")

                        } else if let error = error {
                            // 处理获取下载 URL 的错误
                            print("Error getting download URL: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
            // 监听上传进度
            uploadTask.observe(.progress) { snapshot in
                let percentComplete = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print("Upload progress: \(percentComplete * 100)%")
            }
        }
    }
    
    func downloadImageFromFirebaseStorage(){
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("ProfilePhoto/image_\(user!.email!).jpg")
        
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
