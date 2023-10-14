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

class MyTeams: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var allNum = 0
    var teamNumberArray = [String]()
    var selectNum = 0
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建一个 UICollectionViewFlowLayout 对象
        let layout = UICollectionViewFlowLayout()
        // 设置每行的 cell 个数，例如每行显示3个 cell
        let numberOfItemsPerRow: CGFloat = 2
        // 设置 cell 之间的间距
        let spacing: CGFloat = 20
        // 计算 cell 的宽度
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        // 设置每个 cell 的大小
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        // 设置 cell 之间的水平和垂直间距
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        // 将 layout 应用到 collectionView
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchNumOfCollection()//解决异步问题
        
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
                }
            }else{print("!!!!!!??????\(snapshot)")}
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.TeamLogo.image = UIImage(named: "Yummy")
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
