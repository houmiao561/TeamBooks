//
//  Model.swift
//  TeamBooks
//
//  Created by 侯淼 on 2023/10/6.
//

import Foundation
import UIKit
import Firebase

struct TeamDetailText{
    var name: String
    var date: String
    var password: String
    var introduce: String
    
    var members: [String]
    var comments: [String]
    
    var logo: UIImage
}

struct UserAccountText{
    var email: String
    var password: String
    var Uid: String
}

let db = Firestore.firestore()
