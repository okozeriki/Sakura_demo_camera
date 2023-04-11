//
//  Multiphotos.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/04.
//

import SwiftUI
import PhotosUI

struct Multiphotos: View {
    
    @State var maxSelection: [PhotosPickerItem] = []
    @State var selectedImages: [UIImage] = []
    
    var body: some View {
        VStack{
            if selectedImages.count > 0{
               
                        SliderView(imageNmase: $selectedImages)
//                        ForEach(selectedImages, id:\.self)
//                        {img in
//                            Image(uiImage: img)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 120,height: 120)
//                        }
            }
            else{
                Image(systemName: "photo.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120,height: 120)
                    .clipShape(Circle())
            }
            PhotosPicker(selection: $maxSelection, maxSelectionCount: 5,matching: .any(of: [.images, .not(.videos)])){
                Text("Select Images")
            }
            .onChange(of: maxSelection){newValue in
                Task{
                    selectedImages = []
                    for value in newValue{
                        if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData){
                            selectedImages.append(image)
                        }
                    }
                }
                
            }
        }
    }
}

struct Multiphotos_Previews: PreviewProvider {
    static var previews: some View {
        Multiphotos()
    }
}
