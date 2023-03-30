//
//  Posts.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI

struct Posts: View {
    @State private var recentsPosts: Bool = false
    @State private var createNEwPost: Bool = false
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .hAlign(.center)
            .vAlign(.center)
            .overlay(alignment: .bottomTrailing){
                Button(action: {createNEwPost.toggle()}, label:{ Image(systemName: "plus")
                    .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(13)
                .background(.black,in: Circle())
                }).padding(15)
                
            }
//            .fullScreenCover(isPresented: $createNEwPost){
//                CreateNewPost{ post in
//                    recentsPosts.insert(post, at:0)
//                }
//            }
    }
}

struct Posts_Previews: PreviewProvider {
    static var previews: some View {
        Posts()
    }
}
