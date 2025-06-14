//
//  Cafe24App.swift
//  Cafe24
//
//  Created by 박병호 on 6/14/25.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

@main
struct Cafe24App: App {
    
    
    var body: some Scene {
        WindowGroup {
            
            ContentView()
        }
    }
}
