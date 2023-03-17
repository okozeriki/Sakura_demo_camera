//
//  ImagePickerView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import SwiftUI

struct ImagePickerView:UIViewControllerRepresentable{
    //SwiftUIと繋がるBindingオブジェクト
    @Binding var image:UIImage?
    
    //Coordinatorでdelegateメソッドを処理して、UIKit側の処理をさせる
    class Coordinator:NSObject,PHPickerViewControllerDelegate{
        var parent:ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {return}
            
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
            
        }
        
    }
    //ViewControllerの作成：今回はPickerを返す
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        //delegateにはselfではなくcoordinatorを渡す
        picker.delegate = context.coordinator
        return picker
    }
    //UIViewControllerRepresentable自体のメソッド
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    //UIViewControllerRepresentable自体のメソッド
    func makeCoordinator() -> Coordinator {
        //ImagePickerをparentとしてセット
        Coordinator(parent: self)
    }
    
}
