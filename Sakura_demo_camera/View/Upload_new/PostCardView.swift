//
//  PostCardView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI


struct PostCardView: View {
    var post: Post
    var onUpdate: (Post)-> ()
    var onDelete: () -> ()
    var body: some View {
        HStack{
            Image("Image")
        }
    }
}

