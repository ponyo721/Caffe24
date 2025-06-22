//
//  SharedData.swift
//  Cafe24
//
//  Created by 박병호 on 6/22/25.
//

import Foundation

class SharedData {
    static let shared = SharedData()
    var storeInfoList: [StoreInfo] = []
    
    private init() { }
}
