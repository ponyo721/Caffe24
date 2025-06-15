//
//  ReportView.swift
//  Cafe24
//
//  Created by 박병호 on 6/16/25.
//

import SwiftUI

struct ReportView: View {
    @State private var address: String = ""
    @State private var group: String = ""
    @State private var internetInfo: String? = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var parkingInfo: String? = ""
    @State private var table: String = ""
    @State private var toiletInfo: String? = ""
    @State private var cafeType: String = ""
    @State private var additionalNote: String = ""
    
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("지점명*")) {
                    TextField("지점명", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("카페 타입*")) {
                    HStack {
                        ForEach(["일반", "무인"], id: \.self) { type in
                            Button(action: {
                                cafeType = type
                            }) {
                                HStack {
                                    Image(systemName: cafeType == type ? "largecircle.fill.circle" : "circle")
                                    Text(type)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section(header: Text("전화번호")) {
                    Text("포함 입력 / 정보없음")
                        .foregroundColor(.gray)
                }

                Section(header: Text("테이블")) {
                    Text("몇 테이블 / 많음 / 정보없음")
                        .foregroundColor(.gray)
                }

                Section(header: Text("단체석")) {
                    Text("몇인석 / 정보없음")
                        .foregroundColor(.gray)
                }

                InfoSelectionRow(title: "주차", selection: $parkingInfo)
                InfoSelectionRow(title: "화장실", selection: $toiletInfo)
                InfoSelectionRow(title: "인터넷", selection: $internetInfo)

                Section(header: Text("기타 제보")) {
                    TextEditor(text: $additionalNote)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        )
                }

                Section {
                    Button("제출") {
                        submitForm()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                Section(footer:
                    Text("""
                    · 관리자의 검토를 거쳐 매장이 등록됩니다.
                    · 정확한 이름과 정보를 기재해 주세요.
                    · 가능한 많은 정보를 제공해 주시면 좋습니다!
                    """).font(.footnote).foregroundColor(.gray)
                ) {}
            }
            .navigationTitle("제보하기")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("제출 완료"), message: Text("서버에 저장할 데이터를 확인해보세요."), dismissButton: .default(Text("확인")))
            }
        }
    }

    func submitForm() {
        let data = StoreInfo(
            id: "",
            address: "",
            group: "",
            internet: "",
            latitude: "",
            longitude: "",
            name: "",
            number: "",
            parking: "",
            table: "",
            toilet: "",
            type: "",
            date: ""
        )

        // 서버 전송 로직 여기에 작성
        print("서버로 전송할 데이터: \(data)")
        showAlert = true
    }
}

// 재사용 체크박스 뷰
struct InfoSelectionRow: View {
    let title: String
    @Binding var selection: String?

    let options = ["가능", "불가", "정보 없음"]

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    HStack {
                        Image(systemName: selection == option ? "checkmark.square.fill" : "square")
                        Text(option)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}


#Preview {
    ReportView()
}
