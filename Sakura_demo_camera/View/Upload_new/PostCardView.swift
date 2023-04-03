//
//  PostCardView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestore


struct PostCardView: View {
    var post: Post
    var onUpdate: (Post)-> ()
    var onDelete: () -> ()
    
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListner: ListenerRegistration?
    var body: some View {
        VStack {
            HStack{
                Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35,height: 35)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6){
                    Text(post.userName)
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                //                if let postImageURL = post.imageURL{
                //                    GeometryReader{
                //                        let size = $0.size
                //                        WebImage(url: postImageURL)
                //                            .resizable()
                //                            .aspectRatio(contentMode: .fill)
                //                            .frame(width: size.width, height: size.height)
                //                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                //
                //                    }
                //                    .frame(height: 200)
                //                }
                //                PostInteraction()
                
            }
            .hAlign(.leading)
            .padding(.horizontal,5)
            .overlay(alignment: .topTrailing, content: {
                if post.userUID == userUID{
                    Menu{
                        Button("Delete Post",role: .destructive,action: {deletePost()})
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.caption)
                            .rotationEffect(.init(degrees: -90))
                            .foregroundColor(.black)
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                }
            })
            .onAppear{
                if docListner == nil{
                    guard let postID = post.id else{return}
                    Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot,
                        error in
                        if let snapshot{
                            if snapshot.exists{
                                
                                if let updatedPost = try? snapshot.data(as: Post.self){
                                    onUpdate(updatedPost)
                                }
                            }else{
                                onDelete()
                            }
                        }
                    })
                }
            }
            .onDisappear{
                if let docListner{
                    docListner.remove()
                    self.docListner = nil
                }
            }
            
            if let postImageURL = post.imageURL{
                GeometryReader{
                    let size = $0.size
                    WebImage(url: postImageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 1, style: .continuous))
                    
                }
                .frame(height: 200)
            }
//            PostInteraction()
        }
        .padding(.vertical,5)
    }
    
//    @ViewBuilder
//    func PostInteraction()->some View{
//
//    }
    func deletePost(){
        Task{
            do{
                if post.imageReferenceID != ""{
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            }
        }
    }
    @ViewBuilder
    func PostInteraction() -> some View{
        HStack(spacing: 6){
            Button{
                
            }label: {
                Image(systemName: "hand.thumbsup")
            }
            Text("153")
                .font(.caption)
                .foregroundColor(.gray)
            Button{
                
            }label: {
                Image(systemName: "plus.circle")
            }
            
            Text("123")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .foregroundColor(.black)
//        .padding(.vertical,8)
        .hAlign(.leading)
    }
}

struct PostCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
