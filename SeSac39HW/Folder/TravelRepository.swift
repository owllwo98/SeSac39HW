//
//  TravelRepository.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/5/25.
//

import Foundation
import RealmSwift

protocol TravelRepository {
    func fileURL()
    func fetchProductTable() -> Results<TravelTable>
    func createItem(city: String)
    func deleteItem(data: TravelTable)
    func updateItem(data: TravelTable)
    func createItemInFolder(folder: Folder, city: String)
}


final class TravelTableRepository: TravelRepository {
    private let realm = try! Realm()
    func fileURL() {
        print(realm.configuration.fileURL)
    }
    
    func fetchProductTable() -> RealmSwift.Results<TravelTable> {
        let data = realm.objects(TravelTable.self)
        
        return data
    }
    
    func createItem(city: String) {
        do {
            try realm.write {
                
                let data = TravelTable(city: city)
                
                realm.add(data)
                
                print("realm 저장완료")
            }
        } catch {
            // realm 에 저장을 실패한 경우
            print("realm 에 저장 실패!")
        }
    }
    
    func createItemInFolder(folder: Folder, city: String) {
        do {
            try realm.write {
                
                let data = TravelTable(city: city)
                
                folder.detail.append(data)
                
                print("realm 저장완료")
            }
        } catch {
            // realm 에 저장을 실패한 경우
            print("realm 에 저장 실패!")
        }
    }
    
    func deleteItem(data: TravelTable) {
        do {
            try realm.write {
        
                realm.delete(data)
            }
        } catch {
            print("realm 데이터 삭제 실패")
        }
    }
    
    func updateItem(data: TravelTable) {
        
    }
    
   
    
    
    
}
