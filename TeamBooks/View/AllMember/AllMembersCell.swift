//
//  AllMembersCell.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/10.
//

import UIKit

class AllMembersCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2.0
        profileImage.layer.masksToBounds = true // 剪切超出圆角范围的内容
        profileImage.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
