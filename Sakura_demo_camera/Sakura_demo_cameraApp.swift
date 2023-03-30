//
//  Sakura_demo_cameraApp.swift
//  Sakura_demo_camera
//
//  Created by 本村力希 on 2023/03/16.
//

import SwiftUI
import Firebase

@main
struct Sakura_demo_cameraApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
