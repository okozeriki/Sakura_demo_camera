//
//  UploadPostview.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import PhotosUI
import SwiftUI

struct UploadPostview: View {
    @State private var selectedImageData: Data?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            VStack {
                if let selectedImageData = selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio( contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(maxWidth: UIScreen.main.bounds.width*0.9)
                        .shadow(radius: 5)
                        .overlay(alignment: .topTrailing){
                            Button{
                                withAnimation(.easeOut(duration: 0.25)){
                                    self.selectedImageData = nil
                                }
                            }
                        label:{
                            Image(systemName: "trash")
                                .fontWeight(.bold)
                                .tint(.red)
                        }
                        }
                    
                    Button(action: {}, label: {
                        Text("投稿")
                            .font(.system(size: 16,weight: .semibold))
                            .frame(width: 360, height: 50)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .foregroundColor(.white)
                    }).padding()
                        
                } else {
                    Text("Tap the photo icon to select a photo")
                }
            }.toolbar {
                ToolbarItem(){Image(systemName: "camera").foregroundColor(.mint)
                    .font(.title2)}
                ToolbarItem() {
                    PhotosPicker(selection: $selectedItem, label: {
                        Image(systemName: "photo.fill")
                            .tint(.mint)
                            .font(.title2)
                    })
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                            }
                        }
                    }
                }
            }.navigationTitle("Select a photo")
            
        }
    }
}

struct UploadPostview_Previews: PreviewProvider {
    static var previews: some View {
        UploadPostview()
    }
}
