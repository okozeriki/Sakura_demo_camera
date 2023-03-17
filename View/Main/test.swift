//
//  test.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import SwiftUI

struct test: View {
    @State var showingPicker = false
    @State var image: UIImage?
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            Text("Image")
                .onTapGesture {
                    showingPicker.toggle()
                }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePickerView(image: $image, sourceType: .library)
        }
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
