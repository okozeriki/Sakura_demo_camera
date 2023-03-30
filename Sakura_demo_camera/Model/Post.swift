//
//  Post.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable,Codable {
    @DocumentID var id: String?
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var userName: String 
    var userUID: String
    enum CodingKeys: CodingKey {
        case id
        case imageURL
        case imageReferenceID
        case publishedDate
        case userName
        case userUID

    }
}
//        case userEmail
        
        
//        case likedIDs
//        case dislikedIDs
   
