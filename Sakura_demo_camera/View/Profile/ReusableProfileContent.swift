//
//  ReusableProfileContent.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI

struct ReusableProfileContent: View {
    var user: User
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                HStack(spacing: 12){
                    Image("Image")
                        .resizable()
                        .aspectRatio( contentMode: .fill)
                        .frame(width: 80,height: 80)
                        .clipShape(Circle())
                    Text(user.username)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                }
                .hAlign(.leading)
                .padding(5)
            }
        }
    }
}


