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
    
    let user = Auth.auth().currentUser!
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    var activityIndicatorView: NVActivityIndicatorView!
    
    //下面五个是section0自我介绍部分的信息载体
    var name = ""
    var birthday = ""
    var job = ""
    var introduce = ""
    var selfImage: UIImage?
    
    var teamName = ""   //teamName
    var memberUID = ""  //个人主页的那个人的UID""
    var count = 0   //section1中的cell的个数
    var everyCellInFunc = [[String:String]]()   //中介载体而已
    var finalNameArray:[String] = []    //最终的name数组
    var finalCommentsArray:[String] = []    //最终的comments数组
    var membersCommentsProfile = [UIImage]()
    
    override func viewDidLoad() {
        
        //注册加载动画
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .lineScale, color: .systemYellow, padding: nil)
        activityIndicatorView.center = view.center
        activityIndicatorView.padding = 20
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        
        super.viewDidLoad()
        
        
        
        //注册cell信息
        tableView.register(UINib(nibName: "OneMemberCell", bundle: nil), forCellReuseIdentifier: "OneMemberCell")
        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        
        
        //注册手势
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        
        
        
        
        //执行函数
        downloadTextFromFirebase()
        getNum()
        downLoadCommentsFromFirebas()
        DownLoadSelfImage()
        tableView.allowsSelection = false
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
                destinationVC.onDataReceived = { data in
                    print("Data from B: \(data)")
                    self.tableView.reloadData()
                }
            }
        }
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
        //Comments解决思路是用字典储存UIImage，SelfIntroduce解决方案不变
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OneMemberCell", for: indexPath) as! OneMemberCell
            cell.birthday.text = birthday
            cell.introduce.text = introduce
            cell.job.text = job
            cell.name.text = name
            if self.selfImage == nil{
                cell.selfimage.image = UIImage(named: "Yummy")
            }else{
                cell.selfimage.image = self.selfImage
                self.activityIndicatorView.stopAnimating()
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
            if self.membersCommentsProfile.count == 0{
                cell.profile.image = UIImage(named: "Yummy")
            }else{
                cell.profile.image = membersCommentsProfile[indexPath.row]
                
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
                
                let realK = String(k.prefix(k.count - 2))
                let imageRef = self.storageRef.child("ProfilePhoto/").child("Members \(realK)")
                imageRef.downloadURL { (url, error) in
                    if let downloadURL = url {
                        URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                            if let imageData = data, let image = UIImage(data: imageData) {
                                // 在主线程更新UI
                                DispatchQueue.main.async {
                                    self.membersCommentsProfile.append(image)
                                    self.tableView.reloadData()
                                }
                            }
                        }.resume()
                    }
                }
            }
            
        }
        self.tableView.reloadData()
        }
        
    }
    
    func DownLoadSelfImage(){
        let imageRef = self.storageRef.child("UserIntroducePhoto/").child("\(self.teamName)/").child("Members \(self.user.uid)")
        imageRef.downloadURL { (url, error) in
            if let downloadURL = url {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: downloadURL) {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.selfImage = image
                            self.tableView.reloadData()
                        }
                    }
                }
            }
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
                                            
                                            self.count -= 1
                                            self.everyCellInFunc.remove(at: deleteNum)
                                            self.finalNameArray.remove(at: deleteNum)
                                            self.finalCommentsArray.remove(at: deleteNum)
                                            //self.membersCommentsProfile.remove(at: deleteNum)
                                            self.tableView.reloadData()
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

