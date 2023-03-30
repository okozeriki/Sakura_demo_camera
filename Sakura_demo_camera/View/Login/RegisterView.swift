//
//  RegisterView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/26.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RegisterView: View{
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    
    @Environment(\.dismiss) var dismiss
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading:Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""

    var body: some View {
        VStack (spacing: 10){
            Text("Regester account ")
                .font(.largeTitle.bold())
                .hAlign(.leading)
            
            Text("サインアップしてください")
                .font(.title3)
                .hAlign(.leading)
            VStack(spacing: 20){
                TextField("Username", text: $userName)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top,25)
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                TextField("Password", text: $password)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
    
                Button(action: {registerUser()}, label: {
                    Text("Sign up ")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.black)
                    
                })
                .disableWithOpacity(userName == "" || emailID == "" || password == "")
            }
            HStack{
                Text("Already Have an account?")
                Button(action: {dismiss()}, label: {
                    Text("Login now")
                        .fontWeight(.bold)
                        .foregroundColor(.black
                        )
                })
            }
            .vAlign(.bottom)
       
        
        }
        .vAlign(.top)
            .padding(15)
            .overlay{
                LoadingView(show: $isLoading)
            }
            .alert(errorMessage, isPresented: $showError, actions: {})
        
    }
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                
                let user = User(username: userName, userUID: userUID, userEmail: emailID)
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: {
                    error in
                    if error == nil{
                        print("Saved Successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        logStatus = true
                    }
                })
            }
            catch{
                try await Auth.auth().currentUser?.delete()
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
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
