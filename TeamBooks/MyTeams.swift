//
//  MyTeams.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit

class MyTeams: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
   
    @IBAction func CreatTeam(_ sender: UIButton) {
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
