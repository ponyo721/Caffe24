//
//  FirebaseDBManager.swift
//  Cafe24
//
//  Created by 박병호 on 6/15/25.
//

import Foundation
import FirebaseDatabase

class FirebaseDBManager: ObservableObject {
    @Published var storeInfoList: [StoreInfo] = []
    @Published var changeCount: Int = 0
    
    let ref: DatabaseReference? = Database.database().reference() // (1)
    
    private let encoder = JSONEncoder() // (2)
    private let decoder = JSONDecoder() // (2)
    
    func listenToRealtimeDatabase() {
        print("[FirebaseDBManager] listenToRealtimeDatabase")
        
        guard let databasePath = ref?.child("storeInfoList") else {
            return
        }
        
        databasePath
            .observe(.childAdded) { [weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else {
                    return
                }
                do {
                    let storeData = try JSONSerialization.data(withJSONObject: json)
                    let store = try self.decoder.decode(StoreInfo.self, from: storeData)
                    self.storeInfoList.append(store)
                } catch {
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.childChanged){[weak self] snapshot, _ in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else{
                    return
                }
                do{
                    let storeData = try JSONSerialization.data(withJSONObject: json)
                    let store = try self.decoder.decode(StoreInfo.self, from: storeData)
                    
                    var index = 0
                    for storeItem in self.storeInfoList {
                        if (store.id == storeItem.id){
                            break
                        }else{
                            index += 1
                        }
                    }
                    self.storeInfoList[index] = store
                } catch{
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.childRemoved){[weak self] snapshot in
                guard
                    let self = self,
                    let json = snapshot.value as? [String: Any]
                else{
                    return
                }
                do{
                    let storeData = try JSONSerialization.data(withJSONObject: json)
                    let store = try self.decoder.decode(StoreInfo.self, from: storeData)
                    for (index, storeItem) in self.storeInfoList.enumerated() where store.id == storeItem.id {
                        self.storeInfoList.remove(at: index)
                    }
                } catch{
                    print("an error occurred", error)
                }
            }
        
        databasePath
            .observe(.value){[weak self] snapshot in
                guard
                    let self = self
                else {
                    return
                }
                self.changeCount += 1
            }
    }
    
    func stopListening() {
        print("[FirebaseDBManager] stopListening")
        
        ref?.removeAllObservers()
    }
    
    func addNewStore(storeInfo: StoreInfo) {
        print("[FirebaseDBManager] addNewStore")
        
        self.ref?.child("storeInfoList").child("\(storeInfo.id)").setValue([
            "id": storeInfo.id,
            "address": storeInfo.address,
            "group": storeInfo.group,
            "internet": storeInfo.internet,
            "latitude": storeInfo.latitude,
            "longitude": storeInfo.longitude,
            "name": storeInfo.name,
            "number": storeInfo.number,
            "parking": storeInfo.parking,
            "table": storeInfo.table,
            "toilet": storeInfo.toilet,
            "type": storeInfo.type,
            "date": storeInfo.date
        ])
    }
    
    func deleteStore(key: String) {
        ref?.child("storeInfoList/\(key)").removeValue()
    }
    
    func editStore(storeInfo: StoreInfo) {
        let updates: [String : Any] = [
            "id": storeInfo.id,
            "address": storeInfo.address,
            "group": storeInfo.group,
            "internet": storeInfo.internet,
            "latitude": storeInfo.latitude,
            "longitude": storeInfo.longitude,
            "name": storeInfo.name,
            "number": storeInfo.number,
            "parking": storeInfo.parking,
            "table": storeInfo.table,
            "toilet": storeInfo.toilet,
            "type": storeInfo.type,
            "date": storeInfo.date
        ]
        
        let childUpdates = ["storeInfoList/\(storeInfo.id)": updates]
        for (index, storeItem) in storeInfoList.enumerated() where storeItem.id == storeInfo.id {
            storeInfoList[index] = storeInfo
        }
        self.ref?.updateChildValues(childUpdates)
        
    }
    
}
