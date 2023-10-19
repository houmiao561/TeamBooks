//
//  OneMember.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/14.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class OneMember: UITableViewController {

    var teamName = ""
    var memberUID = ""//个人主页的那个人的UID
    let user = Auth.auth().currentUser!
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    var name = ""
    var birthday = ""
    var job = ""
    var introduce = ""
    
    var count = 0//cell的个数
    
    override func viewWillAppear(_ animated: Bool) {
        downloadTextFromFirebase()
        getNum()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "OneMemberCell", bundle: nil), forCellReuseIdentifier: "OneMemberCell")
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
    }
    
    func getNum(){
        ref.child("Comments").child("\(teamName)").child("\(memberUID)").observeSingleEvent(of: .value) { snapshot in
            if let teamDetailData = snapshot.value as? [String: [String]] {
                for (_,va) in teamDetailData{
                    self.count += va.count
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        }else{
            return count
        }
       
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneMemberCell", for: indexPath) as! OneMemberCell
            cell.birthday.text = birthday
            cell.introduce.text = introduce
            cell.job.text = job
            cell.name.text = name
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
            
            var everyCellInFunc = [[String:String]]()       //存储[UID:Comments]

            ref.child("Comments").child("\(teamName)").child("\(memberUID)").observeSingleEvent(of:.value) { snapshot in
                if let teamDetailData = snapshot.value as? [String: [String]] {
                    
                    for (keyA, value) in teamDetailData{
                        //此时keyA是这个cell的用户UID，没有任何附加String
                        //此时value是[String]
                        //此时value是某一个用户的comments
                        let num = value.count - 1
                        for i in 0...num{
                            everyCellInFunc.append(["\(keyA) \(i)" : value[i]])
                        }
                        
                    }
                    
                    for v in everyCellInFunc[indexPath.row].values{
                        cell.comments.text = v
                    }
                    
                    for k in everyCellInFunc[indexPath.row].keys{
                        //得到真正的不加任何String的UID
                        let realK = String(k.prefix(k.count - 2))
                        
                        //得到profile
                        let imageRef = self.storageRef.child("ProfilePhoto/").child("Members \(realK)")
                        imageRef.downloadURL { (url, error) in
                            if let downloadURL = url {
                                DispatchQueue.global().async {
                                    if let imageData = try? Data(contentsOf: downloadURL) {
                                        let image = UIImage(data: imageData)
                                        DispatchQueue.main.async {
                                            cell.profile.image = image
                                        }
                                    }
                                }
                            }
                            return
                        }
                        
                        
                        //得到name
                        self.ref.child("OneselfIntroduceInTeam").child(self.teamName).child("Members \(realK)").observeSingleEvent(of:.value) { (snapshot) in
                            if let teamData = snapshot.value as? [String: Any] {
                                for (keyB, value) in teamData{
                                    if keyB == "oneselfName"{
                                        for ks in everyCellInFunc[indexPath.row].keys{
                                            if ks == k{
                                                cell.someoneName.text = value as? String
                                            }
                                        }
                                    }
                                }
                            }
                            return
                        }
                    }
                    return
                }
                return
            }
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 500
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 // 设置section之间的间距高度
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray
        
        // 自定义header视图的内容
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 15, width: 200, height: 20) // 调整位置和大小
        label.textColor = UIColor.black // 设置文本颜色
        label.font = UIFont.boldSystemFont(ofSize: 16) // 设置字体和大小
        if section == 0{
            label.text = "My Introduce"
        }else{
            label.text = "Comments"
        }
        
        headerView.addSubview(label)
        return headerView
    }

    func downloadTextFromFirebase(){
        ref.child("OneselfIntroduceInTeam").child(teamName).child("\(memberUID)").observeSingleEvent(of:.value) { (snapshot) in
            if let teamData = snapshot.value as? [String: Any] {
                for (key, value) in teamData{
                    
                    switch key{
                    case "oneselfName": self.name = (value as? String)!
                    case "oneselfIntroduce": self.introduce = (value as? String)!
                    case "oneselfJob":self.job = (value as? String)!
                    case "oneselfBirthday":self.birthday = (value as? String)!
                    default: break
                    }
                    
                }
                self.tableView.reloadData()
            }else{print("!!!!!!??????\(snapshot)")}
        }
    }
    
    @IBAction func addComments(_ sender: Any) {
        performSegue(withIdentifier: "OneMemberToAddComments", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OneMemberToAddComments" {
            if let destinationVC = segue.destination as? AddComments{
                destinationVC.teamName = self.teamName
                destinationVC.memberUID = self.memberUID
            }
        }
    }
    
    
}
