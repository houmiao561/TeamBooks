//
//  AddComments.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/16.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class AddComments: UIViewController {
    
    @IBOutlet weak var addComments: UITextView!
    
    var user = Auth.auth().currentUser!
    var ref = Database.database().reference()
    var activityIndicatorView: NVActivityIndicatorView!
    
    var teamName = ""   //name
    var memberUID = ""  //被点击
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //注册加载信息
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
    }
    
    
    
    @IBAction func button(_ sender: UIButton) {
        activityIndicatorView.startAnimating()
        
        if addComments.text != ""{
            ref.child("Comments").child("\(teamName)").child("\(memberUID)").child("\(user.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if var currentArray = snapshot.value as? [String] {
                    
                    if currentArray.count <= 9{
                        
                        currentArray.append("\(self.addComments.text!)")
                        
                        // 更新Firebase数据库
                        self.ref.child("Comments").child("\(self.teamName)").child("\(self.memberUID)").child("\(self.user.uid)").setValue(currentArray) { (error, ref) in
                            if let error = error {
                                print("Error updating data: \(error)")
                            } else {
                                self.activityIndicatorView.stopAnimating()
                                
                                let alertController = UIAlertController(title: "Great!", message: "Add Succeed.", preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    alertController.dismiss(animated: true)
                                }
                                
                                
                            }
                        }
                    }else{
                        let alertController = UIAlertController(title: "You can't add new Comments", message: "Everyone can only add 10 Comments.If you want to add new Comments.Please Long Pressed your comments and delete it.", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.activityIndicatorView.stopAnimating()
                        self.present(alertController,animated: true,completion: nil)
                    }
                }
                
                else {
                    // 如果之前的数据不是一个数组，你可以创建一个新的数组并添加元素
                    let newArray = ["\(self.addComments.text!)"]
                    
                    // 更新Firebase数据库
                    self.ref.child("Comments").child("\(self.teamName)").child("\(self.memberUID)").child("\(self.user.uid)").setValue(newArray) { (error, ref) in
                        if let error = error {
                            print("Error updating data: \(error)")
                        } else {
                            self.activityIndicatorView.stopAnimating()
                            
                            let alertController = UIAlertController(title: "Great!", message: "Add Succeed.", preferredStyle: .alert)
                            // 显示 UIAlertController
                            self.present(alertController, animated: true, completion: nil)
                            // 延时两秒后自动关闭 UIAlertController
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                alertController.dismiss(animated: true)
                            }
                            
                            
                        }
                    }
                }
            })
        }else{
            let alertController = UIAlertController(title: "Please write something", message: "You can't write anything and public it.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.activityIndicatorView.stopAnimating()
            self.present(alertController,animated: true,completion: nil)
        }
    }
    
    
}
