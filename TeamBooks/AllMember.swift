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
    let user = Auth.auth().currentUser!
    var activityIndicatorView: NVActivityIndicatorView!
    
    var allMembers = 0  //members的数量
    var nameFormMYTEAMS = ""    //teamName
    var membersUIDOfTeam = [String]()   //"Member UID"，注意String(Members )
    var membersNameOfTeam = [String]()  //Name
    var selectMemberUID = ""    //选择的Member的UID
    var membersProfile = [UIImage]()    //Member的头像集合
    var memberName = [String]() //membersName合集
    
    
    override func viewDidLoad() {
        
        //注册加载动画并执行
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        
        
        super.viewDidLoad()
        
        
        
        //注册cell信息
        tableView.register(UINib(nibName: "AllMembersCell", bundle: nil), forCellReuseIdentifier: "AllMembersCell")
        tableView.rowHeight = 70
        
        
        
        
        //执行函数
        fetchNumber()
        fetchMembers()
    }
    
}









//MARK: -Tableview
extension AllMember{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMembers
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMembersCell", for: indexPath) as! AllMembersCell

        if memberName.count == 0{
            cell.memberName.text = nameFormMYTEAMS
        }else{
            cell.memberName.text = memberName[indexPath.row]
        }
        
        if membersProfile.count == 0{
            cell.profileImage.image = UIImage(named: "Yummy")
        }else{
            self.activityIndicatorView.stopAnimating()
            cell.profileImage.image = self.membersProfile[indexPath.row]
        }

        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllMembersToOneMember" {
            if let destinationVC = segue.destination as? OneMember{
                destinationVC.teamName = nameFormMYTEAMS
                destinationVC.memberUID = selectMemberUID
            }
        }
    }
}









//MARK: -Fireabse
extension AllMember{
    
    //先获取数量
    func fetchNumber() {
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        ref.observeSingleEvent(of:.value) { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                self.allMembers = teamData.count
                self.tableView.reloadData()
            }
        }
    }
    
    //再获取名字和UID
    func fetchMembers(){
        self.ref = Database.database().reference().child("Teams").child(nameFormMYTEAMS).child("TeamMembers")
        self.ref.observeSingleEvent(of:.value) { (snapshot, error) in
            if let teamData = snapshot.value as? [String: Any] {
                
                let dispatchGroup = DispatchGroup()
                
                for (key, value) in teamData {
                    self.membersUIDOfTeam.append(key)
                    self.membersNameOfTeam.append(value as! String)
                    
                    let imageRef = self.storageRef.child("ProfilePhoto/").child(key)
                    
                    dispatchGroup.enter()
                    imageRef.downloadURL { (url, error) in
                        defer {
                            dispatchGroup.leave()
                        }
                        if let downloadURL = url {
                            URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                                if let imageData = data, let image = UIImage(data: imageData) {
                                    DispatchQueue.main.async {
                                        self.membersProfile.append(image)
                                        self.tableView.reloadData()
                                    }
                                }
                            }.resume()
                        }else{
                            self.activityIndicatorView.stopAnimating()
                        }
                    }
                    
                    let teamDetailRef = Database.database().reference().child("OneselfIntroduceInTeam").child("\(self.nameFormMYTEAMS)").child("\(key)")
                    
                    dispatchGroup.enter()
                    teamDetailRef.observeSingleEvent(of: .value) { dataSnapshot, _ in
                        defer {
                            dispatchGroup.leave()
                        }
                        
                        if let teamDetailData = dataSnapshot.value as? [String: Any] {
                            for (key, value) in teamDetailData {
                                if key == "oneselfName" {
                                    self.memberName.append(value as! String)
                                    
                                }
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    // 所有异步任务完成后刷新表格
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}


