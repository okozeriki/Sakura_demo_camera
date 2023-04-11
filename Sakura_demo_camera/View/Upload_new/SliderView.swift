//
//  SliderView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/04.
//

import SwiftUI

struct SliderView: View {
    @Binding var imageNmase: [UIImage]
    var body: some View {
        VStack{
            TabView{
                ForEach(imageNmase,id: \.self){img in
                    Image(uiImage: img)
                        .resizable()
                                                        .scaledToFill()
//                                                        .frame(width: 120,height: 120)
                }
            }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

//struct SliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SliderView(imageNmase: )
//    }
//}
