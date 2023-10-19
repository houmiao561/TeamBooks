//
//  CommentsCell.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/16.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var someoneName: UILabel!
    
    @IBOutlet weak var comments: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profile.layer.cornerRadius = profile.frame.size.width / 2.0
        profile.layer.masksToBounds = true // 剪切超出圆角范围的内容
        profile.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
