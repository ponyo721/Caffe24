//
//  ContentView.swift
//  Cafe24
//
//  Created by 박병호 on 6/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coordinator: Coordinator = Coordinator.shared
    
    var body: some View {
        CommonBottomTabView(
            homeView: { VStack {
                NaverMap()
                    .ignoresSafeArea(.all, edges: .top)
            }
            .onAppear {
                Coordinator.shared.checkIfLocationServiceIsEnabled()
            }
            },
            reportView: { ReportView() },
            profileView: { ProfileView() }
        )
    }
}

#Preview {
    ContentView()
}
