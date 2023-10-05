//
//  CollectionViewCell.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/5.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var TeamLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TeamLogo.translatesAutoresizingMaskIntoConstraints = false
        TeamLogo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        TeamLogo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 10.0 // 设置圆角半径
        layer.masksToBounds = true // 剪切超出圆角范围的内容
    }
    
}
