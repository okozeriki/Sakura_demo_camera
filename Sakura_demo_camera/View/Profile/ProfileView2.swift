//
//  ProfileView2.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/09.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import MapKit

struct ProfileView2: View {
    
    @State private var myProfile: User?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @State private var region = MKCoordinateRegion(
        //Mapの中心の緯度経度
        center: CLLocationCoordinate2D(latitude: 37.334900,
                                       longitude: -122.009020),
        //緯度の表示領域(m)
        latitudinalMeters: 750,
        //経度の表示領域(m)
        longitudinalMeters: 750
    )
    
    
    var body: some View {
        NavigationStack{
            VStack{
//                Map(coordinateRegion: $region)
                if let myProfile{
                    ReusableProfileView2(user: myProfile)
                }else{
                    ProgressView()
                }
            }
//            .padding(.vertical,10)
            .refreshable {
                myProfile = nil
                await fetchUserData()
            }
            .navigationTitle("プロフィール")
            .toolbarBackground(.visible, for: .navigationBar)
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("Logout"){
                            logOutUser()
                        }
                        Button("Delete Account" ,role: .destructive){
                            deleteAccount()
                        }
                    }label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .tint(.black)
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay{
            LoadingView(show: $isLoading)
            
        }
        .alert(errorMessage, isPresented: $showError){}
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
    
    func logOutUser(){
        try? Auth.auth().signOut()
        logStatus = false
    }
    func deleteAccount(){
        isLoading = true
        Task{
            do{
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                
                 try await  Auth.auth().currentUser?.delete()
                logStatus = false
            }
            catch{
                await setError(error)
            }
        }
    }
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            isLoading = false
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct ProfileView2_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView2()
    }
}
