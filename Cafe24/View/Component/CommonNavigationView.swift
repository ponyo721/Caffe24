//
//  CommonNavigationView.swift
//  Cafe24
//
//  Created by 박병호 on 6/29/25.
//

import SwiftUI

struct CommonNavigationView: View {
    var body: some View {
        VStack {
            // 상단 바
            HStack {
                // 로고
                NavigationLogoView()
                
                // 드롭박스
                NavigationDropboxView()
                
                // 검색 필드
                NavigationSearchView()
            }
            .padding(.top)
        }
    }
}

//MARK: --
struct NavigationLogoView: View {
    var body: some View {
//        Image(systemName: "leaf")
        Image("LaunchImage")
            .resizable()
            .frame(width: 50, height: 36)
            .padding(.leading)
            .padding(.trailing)
    }
}

struct NavigationDropboxView: View {
    @State var selectedOption = "전체 보기"
    let options = ["전체 보기", "일반 카페", "무인 카페", "즐겨찾기"]
    
    var body: some View {
        Picker("Options", selection: $selectedOption) {
            ForEach(options, id: \.self) { option in
                Text(option)
                    .lineLimit(1)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .scaledToFit()
        .padding(.trailing)
    }
}

struct NavigationSearchView: View {
    @State var initString: String = "Search .."
    
    var body: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
        TextField("Search...", text: $initString)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: 100)
            .padding(.trailing)
    }
}


#Preview {
    CommonNavigationView()
    Text("NavigationView")
}

