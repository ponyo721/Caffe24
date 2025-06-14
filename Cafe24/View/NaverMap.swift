//
//  NaverMap.swift
//  Cafe24
//
//  Created by 박병호 on 6/15/25.
//

import SwiftUI
import NMapsMap

struct NaverMap: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        
        return context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        context.coordinator.updateNaverMapView()
    }
    
}
