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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
   
    @IBAction func CreatTeam(_ sender: UIButton) {
        var ref: DatabaseReference!
        ref = Database.database().reference().child("teams").child("hello")
        ref.observe(.value, with: { (snapshot) in
            if let teamDict = snapshot.value as? [String: Any]{
                let teamName = teamDict["teamName"] as? String
                let teamInt = teamDict["teamIntroduce"] as? String
                print("Team Score: \(teamName!)")
                print("Team Score: \(teamInt)")
                
            }else {print(123)}
        })
        
        ref = Database.database().reference().child("teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for teamSnapshot in teamsSnapshot {
                    // 每个 teamSnapshot 代表 "teams" 中的一个子节点
                    print(teamSnapshot)
                    if let teamDict = teamSnapshot.value as? [String: Any] {
                        let teamName = teamDict["teamName"] as? String
                        let teamIntroduce = teamDict["teamIntroduce"] as? String 
                        print("Team Name: \(teamName)")
                        print("Team Introduce: \(teamIntroduce)")
                    }
                }
            } else {print("123.")}
        })
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
}


extension MyTeams:UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
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
