//
//  ReusablePostsView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ReusablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    
    @Binding var posts: [Post]
    @State var isFetching: Bool = true
    
    @State private var paginationDoc: QueryDocumentSnapshot?
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                    
                }else{
                    if posts.isEmpty{
                        Text("No Posts Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }else{
                        Posts()
                    }
                }
            }
            
            
        }.refreshable {
            
            guard !basedOnUID else{return}
            isFetching = true
            posts = []
            
            paginationDoc = nil
            await fetchPosts()
            
        }.task {
            guard posts.isEmpty else{return}
            await fetchPosts()
        }
    }
    @ViewBuilder
    func Posts()->some View{
        ForEach(posts){post in
            PostCardView(post: post){updatePost in
                
            } onDelete: {
                
                withAnimation(.easeInOut(duration: 0.25)){
                    posts.removeAll{post.id == $0.id}
                }
            }
            .onAppear{
                if post.id == posts.last?.id && paginationDoc != nil{
                    Task{await fetchPosts()}
                }
            }
            Divider()
                .padding(.horizontal,-15)
        }
    }
    func fetchPosts()async{
        do{
            var query: Query!
            if let paginationDoc{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true).limit(to: 20)
            }
            if basedOnUID{
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap{doc -> Post? in try? doc.data(as: Post.self)}
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
            
            
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}
