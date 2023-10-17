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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
