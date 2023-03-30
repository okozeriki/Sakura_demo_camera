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
    @Binding var posts: [Post]
    @State var isFetching: Bool = true
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top,30)
                    
                }else{
                    if posts.isEmpty{
                        Text("No Posts Found")
                    }else{
                        Posts()
                    }
                }
            }
            .refreshable {
                isFetching = true
                posts = []
                await fetchPosts()
                
            }
            .task {
                guard posts.isEmpty else{return}
                await fetchPosts()
            }
        }
    }
    @ViewBuilder
    func Posts()->some View{
        ForEach(posts){post in
            
        }
    }
    func fetchPosts()async{
        do{
            var query: Query!
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true).limit(to: 20)
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap{doc -> Post? in try? doc.data(as: Post.self)}
            await MainActor.run(body: {
                posts = fetchedPosts
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
