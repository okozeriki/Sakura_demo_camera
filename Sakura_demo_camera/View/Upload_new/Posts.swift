//
//  Posts.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/27.
//

import SwiftUI

struct Posts: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNEwPost: Bool = false
    @State private var activeTab: ProductType = .iphone
    @Namespace private var animation
    
//    init(){
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithOpaqueBackground()
//        navigationBarAppearance.backgroundColor = UIColor(named: "originalpink")
////        navigationBarAppearance.isTranslucent = false
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//    }
    var body: some View {
        NavigationStack {
            ScrollableTabs()
            ReusablePostsView(posts: $recentsPosts)
//            Text("Home page")
                .hAlign(.center)
                .vAlign(.center)
//                .overlay(alignment: .bottomTrailing){
//                    Button(action: {createNEwPost.toggle()}, label:{ Image(systemName: "plus")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .padding(13)
//                            .background(.black,in: Circle())
//                    }).padding(15)
//                }
                .navigationTitle("タイムライン")
//                .navigationBarTitleDisplayMode(.inline)
                }
                .fullScreenCover(isPresented: $createNEwPost){
                    CreateNewPost{ post in
                        
                        recentsPosts.insert(post, at: 0)
                    }
            }
        }
    @ViewBuilder
    func ScrollableTabs() -> some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing: 10){
                ForEach(ProductType.allCases,id: \.rawValue){type in
                    Text(type.rawValue)
                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
                        .background(alignment: .bottom, content: {
                            if activeTab == type{
                                Capsule()
                                    .fill(.black)
                                    .frame(height: 5)
                                    .padding(.horizontal, -5)
                                    .offset(y: 15)
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        })
                        .padding(.horizontal,15)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)){
                                activeTab = type
                            }
                        }
                }
            }
            .padding(.vertical,15)
        }
        .background{
            Rectangle()
                .fill(Color("white"))
                .shadow(color: .black.opacity(0.2),radius:5,x:5,y:5)
            
        }
    }
    }


struct Posts_Previews: PreviewProvider {
    static var previews: some View {
        Posts()
    }
}
