//
//  LoginView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/26.
//

import SwiftUI
import Firebase
import FirebaseFirestore
//import FirebaseStorage

struct LoginView: View {
    
    @State var emailID: String = ""
    @State var password: String = ""
    @State var createAccount: Bool = false
    @State var isLoading:Bool = false
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""

    var body: some View {
        VStack (spacing: 10){
            Text("SIgn in ")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("サインインしてください")
                .font(.title3)
                .hAlign(.leading)
            VStack{
                
                VStack (spacing: 15){
                    TextField("Email", text: $emailID)
                        .textContentType(.emailAddress)
                        .border(1, .gray.opacity(0.5))
                        .padding(.top,25)
                
                TextField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
            }
                Button(action: {resetPaaword()}, label: {
                    Text("Reset password?")
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.black)
                        .hAlign(.trailing)
                })
                Button(action: {loginUser()}, label: {
                    Text("Sign in ")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                        .padding(.top,25)
                    
                })
            }
            HStack{
                Text("Dont have an account?")
                Button(action: {
                    createAccount.toggle()
                }, label: {
                    Text("Register now")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                })
            }.vAlign(.bottom)
       
        
        } .vAlign(.top)
            .padding(15)
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .fullScreenCover(isPresented: $createAccount, content: {
                RegisterView()
            })
            .alert(errorMessage,isPresented: $showError,actions: {})
        
            
        
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User found")
                try await fetchUser()
            }
            catch{
                await setError(error)
            }
        }
    }
    func setError(_ error: Error)async{
        await MainActor.run(body:{
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    func fetchUser()async throws {
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            logStatus = true
        })
    }
    
    func resetPaaword(){
        Task{
            do{
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Send")
            }
            catch{
                await setError(error)
            }
        }
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



