//
//  FirebaseDBManager.swift
//  Cafe24
//
//  Created by 박병호 on 6/15/25.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore

class FirebaseDBManager: ObservableObject {
    @Published var storeInfoList: [StoreInfo] = []
    @Published var changeCount: Int = 0
    
    let sharedData = SharedData.shared
    let db = Firestore.firestore()
    let ref: DatabaseReference? = Database.database().reference() // (1)
    
    private let encoder = JSONEncoder() // (2)
    private let decoder = JSONDecoder() // (2)
    
    func getStoreInfoList() {
        print("[FirebaseDBManager] getStoreInfoList")
        
        Task{
            do {
                let snapshot = try await db.collection("StoreInfo").getDocuments()
                print("[FirebaseDBManager] getStoreInfo Success")
                for document in snapshot.documents {
//                    print(">>> \(document.documentID) => \(document.data())")
                    sharedData.storeInfoList.append(setStoreInfo(document))
                }
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func setStoreInfo(_ snapshot:QueryDocumentSnapshot) -> StoreInfo {
        var storeInfo: StoreInfo = StoreInfo()
        
        let data = snapshot.data()
        storeInfo.id = snapshot.documentID
        storeInfo.address = data["address"] as? String
        storeInfo.group = data["group"] as? String
        storeInfo.internet = data["internet"] as? String
        storeInfo.latitude = data["latitude"] as? String
        storeInfo.longitude = data["longitude"]  as? String
        storeInfo.name = data["name"]  as? String
        storeInfo.number = data["number"]  as? String
        storeInfo.parking = data["parking"]  as? String
        storeInfo.table = data["table"]  as? String
        storeInfo.toilet = data["toilet"]  as? String
        storeInfo.type = data["type"]  as? String
        storeInfo.date = data["date"]  as? String
        
#if DEBUG
        print("storeInfo.id: \(storeInfo.id ?? "NULL")")
        print("storeInfo.address: \(storeInfo.address ?? "NULL")")
        print("storeInfo.group: \(storeInfo.group ?? "NULL")")
        print("storeInfo.internet: \(storeInfo.internet ?? "NULL")")
        print("storeInfo.latitude: \(storeInfo.latitude ?? "NULL")")
        print("storeInfo.longitude: \(storeInfo.longitude ?? "NULL")")
        print("storeInfo.name: \(storeInfo.name ?? "NULL")")
        print("storeInfo.number: \(storeInfo.number ?? "NULL")")
        print("storeInfo.parking: \(storeInfo.parking ?? "NULL")")
        print("storeInfo.table: \(storeInfo.table ?? "NULL")")
        print("storeInfo.toilet: \(storeInfo.toilet ?? "NULL")")
        print("storeInfo.type: \(storeInfo.type ?? "NULL")")
        print("storeInfo.date: \(storeInfo.date ?? "NULL")")
#endif
        
        return storeInfo
    }
    
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
