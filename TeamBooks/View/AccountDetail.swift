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
        
        currentUID.text = user.uid
        
        
        // 创建加载动画视图，选择适合您应用的样式、颜色和大小
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        // 将加载动画视图添加到父视图中并居中
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20

        view.addSubview(activityIndicatorView)
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        self.activityIndicatorView.stopAnimating()
        do{
            try Auth.auth().signOut()
            showLogoutAlert()
        }catch{}
    }
    
    func showLogoutAlert() {
        self.activityIndicatorView.stopAnimating()
        let alertController = UIAlertController(title: "Great!", message: "Log Out Succeed.", preferredStyle: .alert)
        // 显示 UIAlertController
        self.present(alertController, animated: true, completion: nil)
        
        // 延时两秒后自动关闭 UIAlertController
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    
    @IBAction func saveAll(_ sender: UIButton) {
        uploadImageToFirebaseStorage(image: photo.image!)
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
    }
    
}






//MARK: -Firebase Photo
extension AccountDetail{
    
    func uploadImageToFirebaseStorage(image: UIImage) {
        let imageRef = storageRef.child("ProfilePhoto/").child("Members \(user.uid)")
        if let imageData = image.jpegData(compressionQuality: 0.01) {
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
        let imageRef = storageRef.child("ProfilePhoto/").child("Members \(user.uid)")
        
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.photo.image =  image
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
