//
//  Posts2.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/04/15.
//

import SwiftUI

struct Posts2: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNEwPost: Bool = false
    @State private var activeTab: ProductType = .iphone
    @Namespace private var animation
    var body: some View {
        
        CreateNewPost{ post in
            
            recentsPosts.insert(post, at: 0)
        }
        
    }
}

struct Posts2_Previews: PreviewProvider {
    static var previews: some View {
        Posts2()
    }
}
