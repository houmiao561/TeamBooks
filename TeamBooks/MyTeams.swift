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

class MyTeams: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var allNum = 0
    var teamNumberArray = [String]()
    var selectNum = 0
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 15
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        // 将 layout 应用到 collectionView
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchNumOfCollection()//解决异步问题
        
        teamNumberArray.sort()
    }
    
    @IBAction func CreatTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
    @IBAction func AddTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToAddTeam", sender: sender)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 计算每行的cell个数，例如每行显示3个cell
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 10 // cell之间的间距
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}
