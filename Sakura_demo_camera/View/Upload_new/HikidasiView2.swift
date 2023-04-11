//
//  HikidasiView2.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/09.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct HikidasiView2: View {
    @State private var myProfile: User?
    @State private var recentsPosts: [Post] = []
    var body: some View {
        VStack {
            if let myProfile{
                HikidasiView(user: myProfile,posts: $recentsPosts)
            }
            else{
                ProgressView()
            }
            
        }
        .refreshable {
            myProfile = nil
            await fetchUserData()
        }
        .task {
            if myProfile != nil{return}
            await fetchUserData()
        }
    }
    func fetchUserData()async{
        guard let userUID = Auth.auth().currentUser?.uid else{return}
        guard let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)else{return}
        await MainActor.run(body: {
            myProfile = user
        })
    }
}

struct HikidasiView2_Previews: PreviewProvider {
    static var previews: some View {
        HikidasiView2()
    }
}
