//
//  OneMemberCell.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/15.
//

import UIKit

class OneMemberCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var introduce: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
