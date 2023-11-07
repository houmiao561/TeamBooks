//
//  AccountDetail.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/6.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import NVActivityIndicatorView

class AccountDetail: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var currentUID: UITextField!
    
    var activityIndicatorView: NVActivityIndicatorView!

    let storageRef = Storage.storage().reference()
    let user = Auth.auth().currentUser!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadImageFromFirebaseStorage()
        currentUID.text = user.uid
        
        
        //注册点击手势
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        photo.addGestureRecognizer(tapGestureRecognizer)
        photo.isUserInteractionEnabled = true
        photo.layer.cornerRadius = photo.frame.size.width / 2.0
        photo.layer.masksToBounds = true // 剪切超出圆角范围的内容
        photo.contentMode = .scaleAspectFill
        
        
        //注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        
        
        //执行完downloadImageFromFirebaseStorage()之后动画结束
        self.activityIndicatorView.startAnimating()
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        do{
            try Auth.auth().signOut()
            showLogoutAlert()
        }catch{}
    }
    
    @IBAction func deleteAcc(_ sender: Any) {
        let alertController = UIAlertController(title: "If you want to delete your Account?", message: "This operation cannot be undone.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default){ (action) in
            do {
                self.activityIndicatorView.startAnimating()
                if let navigationController = self.navigationController {
                    try Auth.auth().signOut() // 登出当前用户
                    self.user.delete { (error) in
                        if let error = error {
                            print("Error deleting user: \(error.localizedDescription)")
                        } else {
                            self.activityIndicatorView.stopAnimating()
                            navigationController.popToRootViewController(animated: true)
                        }
                    }
                }
            } catch { print("Error signing out") }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    func showLogoutAlert() {
        self.activityIndicatorView.stopAnimating()
        let alertController = UIAlertController(title: "Great!", message: "Log Out Succeed.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        // 延时两秒后自动关闭 UIAlertController
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func saveAll(_ sender: UIButton) {
        self.activityIndicatorView.startAnimating()
        uploadImageToFirebaseStorage(image: photo.image!)
    }
}






//MARK: -ImagePicker
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
    }
    
}






//MARK: -Firebase Photo
extension AccountDetail{
    //上传图片
    func uploadImageToFirebaseStorage(image: UIImage) {
        let imageRef = storageRef.child("ProfilePhoto/").child("Members \(user.uid)")
        if let imageData = image.jpegData(compressionQuality: 0.0001) {
            // 开始上传图片
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    self.activityIndicatorView.stopAnimating()
                    let alertController = UIAlertController(title: "Great!", message: "Up Load Profile Succeed.", preferredStyle: .alert)
                    // 显示 UIAlertController
                    self.present(alertController, animated: true, completion: nil)
                    // 延时两秒后自动关闭 UIAlertController
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alertController.dismiss(animated: true, completion: nil)
                        self.navigationController!.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //下载图片
    func downloadImageFromFirebaseStorage(){
        let imageRef = storageRef.child("ProfilePhoto/").child("Members \(user.uid)")
        
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.photo.image =  image
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            } else if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
            }
        }
        
    }
}
