//
//  MyTeams.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import NVActivityIndicatorView

class MyTeams: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var ref123 = Database.database().reference()
    var allNum = 0
    var teamNumberArray = [String]()
    var selectNum = 0
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建加载动画视图，选择适合您应用的样式、颜色和大小
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        // 将加载动画视图添加到父视图中并居中
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchNumOfCollection()//解决异步问题
        
        teamNumberArray.sort()
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.reloadData()
        
        
    }
    
    @IBAction func CreatTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
    @IBAction func AddTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToAddTeam", sender: sender)
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location) {
                let item = indexPath.item
                
                let alertController = UIAlertController(title: "If you want to quit This Team?", message: "This action will delete All Your Info In This Team", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                let detailAction = UIAlertAction(title: "Yes", style: .default) { action in
                    
                    let deleteTeamsRef = self.ref123.child("Teams").child("\(self.teamNumberArray[item])").child("TeamMembers").child("Members \(self.user!.uid)")
                    deleteTeamsRef.removeValue(){ error,_ in
                        if let error = error {
                            print("Failed to remove data: \(error.localizedDescription)")
                        } else {
                            
                            
                            let deleteIntroduceRef = self.ref123.child("OneselfIntroduceInTeam").child("\(self.teamNumberArray[item])")
                            deleteIntroduceRef.child("Members \(self.user!.uid)").removeValue(){error,_ in
                                if let error = error {
                                    print("Failed to remove data: \(error.localizedDescription)")
                                } else {
                                    
                                    
                                    let deleteUserRef = self.ref123.child("Users").child("\(self.user!.uid)").child("Teams")
                                    deleteUserRef.child("Team \(self.teamNumberArray[item])").removeValue(){error,_ in
                                        if let error = error {
                                            print("Failed to remove data: \(error.localizedDescription)")
                                        } else {
                                            print("Data removed successfully")
                                            // 在数据成功删除后，刷新collectionView或执行其他操作
                                            self.teamNumberArray.remove(at: item)
                                            self.collectionView.reloadData()
                                            return
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(detailAction)
                self.present(alertController,animated: true,completion: nil)
                
            }
        }
    }

    
}










extension MyTeams:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func fetchNumOfCollection() {
        self.ref = Database.database().reference().child("Users").child(user!.uid).child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                self.allNum = teamData.count
                self.collectionView.reloadData()
                
                for teamDatas in teamData{
                    self.teamNumberArray.append(teamDatas.value as! String)
                    self.teamNumberArray.sort()
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        
        let imageRef = storageRef.child("TeamLogo/").child("\(teamNumberArray[indexPath.item])")
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            cell.TeamLogo.image = image
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        self.activityIndicatorView.stopAnimating()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectNum = indexPath.item
        performSegue(withIdentifier: "MyTeamToTabBar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyTeamToTabBar" {
            if let destinationVC = segue.destination as? TabBar,
               let item1VC = destinationVC.viewControllers?[0]as? TeamDetail,
               let item2VC = destinationVC.viewControllers?[1] as? AllMember {
                item1VC.nameFormMYTEAMS = teamNumberArray[selectNum]
                item2VC.nameFormMYTEAMS = teamNumberArray[selectNum]
            }
        }
    }
    
}
