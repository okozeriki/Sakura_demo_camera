//
//  youtube_kavsoft.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/19.
//

import SwiftUI
import PhotosUI

struct youtube_kavsoft: View {
    @State var postText: String = ""
    @State var postImageData: Data?
    @State var showImagePicker: Bool = false
    @State private var photoitem: PhotosPickerItem?
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            VStack {
                HStack(){
                    Menu{
                        Button("Cancel",role: .destructive){
                            dismiss()
                        }
                    } label: {
                        Text("Cancel")
                            .font(.callout)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button(action: {}, label: {
                        Text("Post")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(.horizontal,20)
                            .padding(.vertical,6)
                            .background(.black,in:Capsule())
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
            }
            
                VStack{
                    
                    if let postImageData,let image = UIImage(data: postImageData){
                        GeometryReader{
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width,height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                    Spacer()
                    
                }
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.title3)
                    .foregroundColor(.black)
            })
            .photosPicker(isPresented: $showImagePicker, selection: $photoitem)
            .onChange(of: photoitem){
                newValue in
                if let newValue{
                    Task{
                        if let rawImageData = try? await newValue.loadTransferable(type: Data.self),let image = UIImage(data: rawImageData),let compressedImageData = image.jpegData( compressionQuality: 0.5){
                            await MainActor.run(body:{
                                postImageData = compressedImageData
                                photoitem = nil
                            })
                        }
                    }
                }
            }
        }
        
    }
}

struct youtube_kavsoft_Previews: PreviewProvider {
    static var previews: some View {
        youtube_kavsoft()
    }
}
