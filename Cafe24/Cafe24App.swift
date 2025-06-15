//
//  Cafe24App.swift
//  Cafe24
//
//  Created by 박병호 on 6/14/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("application didFinishLaunchingWithOptions")
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct Cafe24App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isLaunch {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.linear) {
                                self.isLaunch = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
