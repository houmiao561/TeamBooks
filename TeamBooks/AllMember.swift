//
//  AddMember.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/4.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AllMember: UITableViewController {

    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var allMembers = 0
    var nameFormMYTEAMS = ""
    var membersOfTeam = [String]()
    private let user = Auth.auth().currentUser!
    var selectMemberUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AllMembersCell", bundle: nil), forCellReuseIdentifier: "AllMembersCell")
        fetchNumber()
        fetchMembers()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMembersCell", for: indexPath) as! AllMembersCell
        
        let imageRef = storageRef.child("ProfilePhoto/").child("\(membersOfTeam[indexPath.item])")
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                if let imageData = try? Data(contentsOf: downloadURL) {
                    let image = UIImage(data: imageData)
                    cell.profileImage.image = image
                }
            } else if let error = error {
                print("Error getting download URL: \(error.localizedDescription)")
            }
        }
        
        cell.memberName.text = membersOfTeam[indexPath.item]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMembers
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ref = Database.database().reference().child("Teams").child("\(nameFormMYTEAMS)").child("TeamMembers")
        ref.observe(.value, with: { (snapshot) in
            if let teamDetailData = snapshot.value as? [String: Any] {
                for (key, value) in teamDetailData{
                    if value as! String == self.membersOfTeam[indexPath.row] {
                        self.selectMemberUID = key
                        self.performSegue(withIdentifier: "AllMembersToOneMember", sender: indexPath.row)
                    }else{print("if value as! String == self.membersOfTeam[indexPath.row]")}
                }
            }else{print("if let teamDetailData = snapshot.value as? [String: Any]")}
            
        })
        
    }
    
    func fetchNumber() {
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        ref.observe(.value, with: { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                self.allMembers = teamData.count
                self.tableView.reloadData()
            }else{print("!!!!!!??????\(snapshot)")}
        })
    }
    
    func fetchMembers(){
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        ref.observe(.value, with: { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                
                for teamDatas in teamData{
                    self.membersOfTeam.append(teamDatas.value as! String)
                }
                
                self.tableView.reloadData()
            }else{print("!!!!!!??????\(snapshot)")}
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllMembersToOneMember" {
            if let destinationVC = segue.destination as? OneMember{
                destinationVC.teamName = nameFormMYTEAMS
                destinationVC.memberUID = selectMemberUID
            }
        }
    }
    
    
}


