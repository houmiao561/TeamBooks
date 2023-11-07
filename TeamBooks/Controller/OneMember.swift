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
import NVActivityIndicatorView

class OneMember: UITableViewController {
    
    var teamName = ""
    var memberUID = ""//个人主页的那个人的UID""
    let user = Auth.auth().currentUser!
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    //下面四个时section0的信息载体
    var name = ""
    var birthday = ""
    var job = ""
    var introduce = ""
    
    var count = 0//section1中的cell的个数
    var everyCellInFunc = [[String:String]]()//中介载体而已
    var finalNameArray:[String] = []
    var finalCommentsArray:[String] = []
    var activityIndicatorView: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        // 创建加载动画视图，选择适合您应用的样式、颜色和大小
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        
        
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        
        //注册cell信息
        tableView.register(UINib(nibName: "OneMemberCell", bundle: nil), forCellReuseIdentifier: "OneMemberCell")
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        
        //注册手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        tableView.reloadData()
        
        //执行函数
        downloadTextFromFirebase()
        getNum()
        downLoadCommentsFromFirebas()
        self.tableView.reloadData()
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













//MARK: -Gesture
extension OneMember{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: location){
                
                // 行位置
                let section = indexPath.section
                let row = indexPath.row
                // 要删除的值
                let valueToDelete = "\(everyCellInFunc[row].values.first!)"
                // 进入循环并且child("\(deleteNum)")
                var deleteNum = 0

                if section == 0 {
                    return
                } else {
                    let realK = String(self.everyCellInFunc[row].keys.first!.prefix(self.everyCellInFunc[row].keys.first!.count - 2))
                    if self.user.uid == realK{
                        let alertController = UIAlertController(title: "If you want to delete your Comments?", message: "This operation cannot be undone.", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Yes", style: .default){ (action) in
                            self.ref.child("Comments").child("\(self.teamName)").child("\(self.memberUID)").child("\(self.user.uid)").observeSingleEvent(of: .value) { DataSnapshot,error in
                                if let teamDetailData = DataSnapshot.value as? [String]{
                                    for teamDetailDataChild in teamDetailData{
                                        if teamDetailDataChild == valueToDelete{
                                            self.ref.child("Comments").child("\(self.teamName)").child("\(self.memberUID)").child("\(self.user.uid)").child("\(deleteNum)").removeValue()
                                            self.navigationController?.popViewController(animated: true)
                                            return
                                        }
                                        deleteNum += 1
                                    }
                                }
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(yesAction)
                        self.present(alertController,animated: true,completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "You can't delete others Comments", message: "It isn't your Comments", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController,animated: true,completion: nil)
                    }
                }
            }
        }
    }
}












//MARK: -Download Form Firebase
extension OneMember{
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
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func downLoadCommentsFromFirebas(){
        ref.child("Comments").child("\(teamName)").child("\(memberUID)").observeSingleEvent(of:.value) { snapshot,error  in
            if let teamDetailData = snapshot.value as? [String: [String]] {
                for (keyA, value) in teamDetailData{
                    //此时keyA是这个cell的用户UID，没有任何附加String
                    //此时value是[String]
                    //此时value是某一个用户的comments
                    let num = value.count - 1
                    for i in 0...num{
                        self.everyCellInFunc.append(["\(keyA) \(i)" : value[i]])
                        // [ UID 0: Comments1 ]
                    }
                }
            }
        
        for vs in self.everyCellInFunc{  // vs: [ UID 0: Comments1 ] 此时UID有序号
            
            for v in vs.values{
                self.finalCommentsArray.append(v)
            }
            for k in vs.keys{
                self.finalNameArray.append(k)
            }
            
        }
        self.tableView.reloadData()
        }
        
    }
    
}








//MARK: -Header
extension OneMember{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemYellow
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 10, width: 200, height: 20) // 调整位置和大小
        label.textColor = UIColor.black // 设置文本颜色
        label.font = UIFont.boldSystemFont(ofSize: 20) // 设置字体和大小
        if section == 0{
            label.text = "My Introduce"
        }else{
            label.text = "Comments"
        }
        
        headerView.addSubview(label)
        return headerView
    }
}










//MARK: -TableView and Cell
extension OneMember{
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
            
            let imageRef = self.storageRef.child("UserIntroducePhoto").child("\(self.teamName)").child("Member \(self.user.uid)")
            imageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                        if let imageData = data, let image = UIImage(data: imageData) {
                            // 在主线程更新UI
                            DispatchQueue.main.async {
                                cell.selfimage.image = image
                                self.tableView.reloadData()
                            }
                        }
                    }.resume()
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) as! CommentsCell
            
            //显示评论
            cell.comments.text = finalCommentsArray[indexPath.row]
            
            //显示name而不是email，所以需要一步转换过程
            let realK = String(finalNameArray[indexPath.row].prefix(finalNameArray[indexPath.row].count - 2))
            ref.child("OneselfIntroduceInTeam").child(self.teamName).child("Members \(realK)").observeSingleEvent(of: .value) { Snapshot,error in
                if let thisMember = Snapshot.value as? [String:String] {
                    for (key, value) in thisMember{
                        if key == "oneselfName"{
                            cell.someoneName.text = value
                        }
                    }
                }
            }
            
            //显示头像
            let imageRef = self.storageRef.child("ProfilePhoto/").child("Member \(realK)")
            imageRef.downloadURL { (url, error) in
                if let downloadURL = url {
                    URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                        if let imageData = data, let image = UIImage(data: imageData) {
                            // 在主线程更新UI
                            DispatchQueue.main.async {
                                cell.profile.image = image
                                self.tableView.reloadData()
                            }
                        }
                    }.resume()
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 600
        } else {
            return 180
        }
    }
}
