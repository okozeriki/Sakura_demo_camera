//
//  ContentView.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        
        if logStatus{
            MaintabView()
        }else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
