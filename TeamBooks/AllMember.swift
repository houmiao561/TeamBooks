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
import NVActivityIndicatorView

class AllMember: UITableViewController {

    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var allMembers = 0
    var nameFormMYTEAMS = ""//teamName
    var membersUIDOfTeam = [String]() //"Member UID"
    var membersNameOfTeam = [String]()
    private let user = Auth.auth().currentUser!
    var selectMemberUID = ""
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        // 创建加载动画视图，选择适合您应用的样式、颜色和大小
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        // 将加载动画视图添加到父视图中并居中
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AllMembersCell", bundle: nil), forCellReuseIdentifier: "AllMembersCell")
        tableView.rowHeight = 70
        fetchNumber()
        fetchMembers()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMembersCell", for: indexPath) as! AllMembersCell

        ref = Database.database().reference().child("OneselfIntroduceInTeam").child("\(nameFormMYTEAMS)").child("\(membersUIDOfTeam[indexPath.row])")
        ref.observeSingleEvent(of: .value) { DataSnapshot in
            if let teamDetailData = DataSnapshot.value as? [String: Any] {
                for (key, value) in teamDetailData{
                    if key == "oneselfName"{
                        cell.memberName.text = (value as! String)
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }

        // 异步下载图片
        let imageRef = storageRef.child("ProfilePhoto/").child("\(membersUIDOfTeam[indexPath.item])")
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                    if let imageData = data, let image = UIImage(data: imageData) {
                        // 在主线程更新UI
                        DispatchQueue.main.async {
                            cell.profileImage.image = image
                        }
                    }
                }.resume()
            }
        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMembers
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ref = Database.database().reference().child("Teams").child("\(nameFormMYTEAMS)").child("TeamMembers")
        ref.observeSingleEvent(of:.value) { (snapshot) in
            if let teamDetailData = snapshot.value as? [String: Any] {
                for (key, value) in teamDetailData{
                    if value as! String == self.membersNameOfTeam[indexPath.row] {
                        self.selectMemberUID = key
                        self.performSegue(withIdentifier: "AllMembersToOneMember", sender: indexPath.row)
                    }
                }
            }
        }
        
    }
    
    func fetchNumber() {
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        ref.observeSingleEvent(of:.value) { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                self.allMembers = teamData.count
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchMembers(){
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        ref.observeSingleEvent(of:.value) { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                
                for (key,value) in teamData{
                    self.membersUIDOfTeam.append(key)
                    self.membersNameOfTeam.append(value as! String)
                }
                
                self.tableView.reloadData()
            }
        }
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


