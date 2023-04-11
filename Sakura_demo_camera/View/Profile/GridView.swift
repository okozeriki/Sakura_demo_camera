//
//  GridView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/07.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct GridView: View {
    @Binding var posts: [Post]
    var images: [String] = ["image1","image2","image3"]
    var columnGrid: [GridItem] = [GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1),GridItem(.flexible(),spacing: 1)]
    
    var body: some View {
        LazyVGrid(columns: columnGrid,spacing: 1){
            ForEach(posts, id: \.self){image in
                
                WebImage(url:image.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width / 3 - 1,height: UIScreen.main.bounds.width / 3 - 1)
                    .clipped()
            }
        }
    }
}

//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}
