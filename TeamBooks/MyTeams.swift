//
//  MyTeams.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
class MyTeams: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var num: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchNumOfCollection()//解决异步问题
    }
   
    @IBAction func CreatTeam(_ sender: UIButton) {
        
        ref = Database.database().reference().child("Teams").child("hello")
        ref.observe(.value, with: { (snapshot) in
            if let teamDict = snapshot.value as? [String: Any]{
                let teamName = teamDict["teamName"] as? String
                let teamInt = teamDict["teamIntroduce"] as? String
                print("Team Score: \(teamName!)")
                print("Team Score: \(teamInt)")
                
            }else {print(123)}
        })
        
        ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                print(teamsSnapshot.count)
                for teamSnapshot in teamsSnapshot {
                    // 每个 teamSnapshot 代表 "teams" 中的一个子节点
                    print(teamSnapshot)
                    if let teamDict = teamSnapshot.value as? [String: Any] {
                        let teamName = teamDict["teamName"] as? String
                        let teamIntroduce = teamDict["teamIntroduce"] as? String
                        print("Team Name: \(teamName ?? "123233")")
                        print("Team Introduce: \(teamIntroduce ?? "456566")")
                    }
                }
            } else {print("123.")}
        })
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
}


extension MyTeams:UICollectionViewDataSource, UICollectionViewDelegate{
    func fetchNumOfCollection(){
        self.ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                print(teamsSnapshot.count)
                self.num = teamsSnapshot.count
                self.collectionView.reloadData()
            }
        })
    }//解决异步进行的问题
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.TeamLogo.image = UIImage(named: "Yummy")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MyTeamToTabBar", sender: self)
    }
}
