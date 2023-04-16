//
//  MaintabView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import SwiftUI

struct MaintabView: View {
    var body: some View {
        NavigationView {
            TabView{
                ProfileView()
                    .tabItem{
                        Image(systemName: "magnifyingglass")
                        Text("探す")
                    }
                Posts2()
                    .tabItem{
                        Image(systemName: "plus.square")
                        Text("投稿")
                    }
                Posts()
                    .tabItem{
                        Image(systemName: "doc.text.image")
                        Text("タイムライン")
                    }
                
            }
                .navigationBarTitleDisplayMode(.inline)
                .accentColor(.black)
        }
    }
}

struct MaintabView_Previews: PreviewProvider {
    static var previews: some View {
        MaintabView()
    }
}
