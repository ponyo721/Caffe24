//
//  BaseView.swift
//  Cafe24
//
//  Created by 박병호 on 6/15/25.
//

import SwiftUI

struct CommonBottomTabView<Content1: View, Content2: View, Content3: View>: View {
    let homeView: () -> Content1
    let reportView: () -> Content2
    let profileView: () -> Content3
    
    var body: some View {
        TabView {
            homeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            reportView()
                .tabItem {
                    Label("Report", systemImage: "magnifyingglass")
                }
            
            profileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

// 각 탭에 들어갈 뷰들
struct HomeView: View {
    var body: some View {
        Text("Home")
            .font(.largeTitle)
    }
}

struct ReportView: View {
    var body: some View {
        Text("Report")
            .font(.largeTitle)
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile")
            .font(.largeTitle)
    }
}

#Preview {
    CommonBottomTabView(
        homeView: { HomeView() },
        reportView: { ReportView() },
        profileView: { ProfileView() }
    )
}

