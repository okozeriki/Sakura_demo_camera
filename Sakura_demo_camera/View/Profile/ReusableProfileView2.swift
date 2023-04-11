//
//  ReusableProfileContent.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI

struct ReusableProfileView2: View {
    var user: User
        @State private var fetchedPosts: [Post] = []
        
        var body: some View {
            ScrollView(.vertical,showsIndicators: false){
                LazyVStack{
    //                HStack(spacing: 12){
    //                    Image("Image")
    //                        .resizable()
    //                        .aspectRatio( contentMode: .fill)
    //                        .frame(width: 35,height: 35)
    //                        .clipShape(Circle())
                        Text(user.username)
                            .font(.title3)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
    //                }
    //                .hAlign(.leading)
    //                .padding(5)
                    
                   
                       
                        
                        Text("投稿")
                    ReusablePostsView(basedOnUID: true,uid: user.userUID, posts: $fetchedPosts)
                }
            }
        }
    }

