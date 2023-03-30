//
//  User.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/26.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable {
    @DocumentID var id: String?
    var username: String
    var userUID: String
//    var userProfileURL: URL
    var userEmail: String
    
    enum CodingKeys: CodingKey {
    case id
        case username
        case userUID
        case userEmail
//        case userProfileURL
    }
}


