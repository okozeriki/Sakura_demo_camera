//
//  CreateNewPost.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct CreateNewPost: View {
    var onPost: (Post)->()
    
    @State private var postImageData: Data?
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    @Environment(\.dismiss) var dismiss
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading:Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    
    var body: some View {
        VStack{
            HStack{
                Menu{
                    Button("Cancel",role: .destructive){
                        dismiss()
                        
                    }
                }label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                Button(action: {
                    createPost()
                }, label: {
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,6)
                        .background(.black,in: Capsule())
                })
            }
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            Spacer()
                VStack(spacing: 15){
                    
                
                    if let postImageData, let image = UIImage(data: postImageData){
                        GeometryReader{_ in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width)
                                .clipShape(RoundedRectangle(cornerRadius: 3,style: .continuous))
                                .hAlign(.center)
                                .vAlign(.center)
                                .overlay(){
                                    HStack{
                                        Spacer()
                                        Button{
                                            withAnimation(.easeOut(duration: 0.25)){
                                                self.postImageData = nil
                                            }
                                        }
                                    label:{
                                        Image(systemName: "trash")
                                            .fontWeight(.bold)
                                            .tint(.red)
                                    }}
                                }
                                
                                
                        
                    }
                }
                    else{
                        Text("写真を選択してください")
                            .vAlign(.center)
                    }
            }
        
            Divider()
            HStack{
                Button(action: {}, label: {
                    Image(systemName: "camera")
                        .font(.title)
                        .foregroundColor(.black)
                    
                }).hAlign(.leading)
                Button(action: {showImagePicker.toggle()}, label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title)
                        .foregroundColor(.black)
                    
                })
                    
            }.padding(.horizontal,30)
                .padding(.vertical,10)
        }.vAlign(.top)
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem){
            newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self),let image = UIImage(data: rawImageData),let compressedImageData = image.jpegData(compressionQuality: 0.5){
                        await MainActor.run(body:{
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
            .alert(errorMessage, isPresented: $showError, actions: {})
            .overlay{
                LoadingView(show: $isLoading)
            }
        
    }
    func createPost(){
        isLoading = true
        Task {
            do{
                let imageReferenceID = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                if let postImageData {
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    let post = Post(imageURL: downloadURL, imageReferenceID: imageReferenceID, userName: userNameStored, userUID: userUID)
                    try await createDocumentAtFirebase(post)
                    print("post ok")
                }else{
                    print("post no")
                    let post = Post(userName: userNameStored, userUID: userUID)
                    try await createDocumentAtFirebase(post)
                    
                }
            }catch{
                print("post no2")
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post)async throws{
        let _ = try Firestore.firestore().collection("Posts").addDocument(from: post, completion: {error in if error == nil{
            isLoading = false
            onPost(post)
            dismiss()
        }})
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct CreateNewPost_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPost{_ in}
    }
}
