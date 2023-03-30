//
//  View+Extension.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/26.
//

import SwiftUI

extension View{
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.6 : 1)
        
    }
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity,alignment: alignment)
    }
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity,alignment: alignment)
    }
    func border(_ width:CGFloat,_ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5,style: .continuous)
                    .fill(color)
            }
    }

}
