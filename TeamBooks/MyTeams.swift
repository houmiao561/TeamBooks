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
    var allNum = 0
    var teamNumberArray = [String]()
    var selectNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchNumOfCollection()//解决异步问题
        
        
        ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
//                print(teamsSnapshot)
                for teamSnapshot in teamsSnapshot {
                    //print(teamSnapshot.key)
                    self.teamNumberArray.append(teamSnapshot.key)
                }
            } else {print("123.")}
        })
        
        
        
    }
   
    @IBAction func CreatTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "MyTeamToCreatTeam", sender: sender)
    }
    
}










extension MyTeams:UICollectionViewDataSource, UICollectionViewDelegate{
    func fetchNumOfCollection(){
        self.ref = Database.database().reference().child("Teams")
        ref.observe(.value, with: { (snapshot) in
            if let teamsSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                self.allNum = teamsSnapshot.count
                self.collectionView.reloadData()
            }
        })
    }//解决异步进行的问题
    
    
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
    
    
}








extension MyTeams{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyTeamToTabBar" {
            if let destinationVC = segue.destination as? TabBar {
                destinationVC.teamName = teamNumberArray[selectNum]
            }
        }
        
    }
}
