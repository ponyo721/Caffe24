//
//  StoreInfo.swift
//  Cafe24
//
//  Created by 박병호 on 6/16/25.
//

import Foundation

struct StoreInfo : Codable, Identifiable, Hashable {
    var id: String?
    var address: String?
    var group: String?
    var internet: String?
    var latitude: String?
    var longitude: String?
    var name: String?
    var number: String?
    var parking: String?
    var table: String?
    var toilet: String?
    var type: String?
    var date: String?
}
