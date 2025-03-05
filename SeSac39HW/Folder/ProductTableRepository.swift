////
////  ProductTableRepository.swift
////  SeSac39HW
////
////  Created by 변정훈 on 3/5/25.
////
//
//import Foundation
//import RealmSwift
//
//protocol ProductRepository {
//    func fileURL()
//    func fetchProductTable() -> Results<ProductTable>
//    func createItem()
//    func deleteItem(data: ProductTable)
//    func updateItem(data: ProductTable)
//    func createItemInFolder(folder: Folder)
//}
//
//
//final class ProductTableRepository: ProductRepository {
//    private let realm = try! Realm()
//    
//    func fileURL() {
//        print(realm.configuration.fileURL)
//    }
//    
//    func fetchProductTable() -> Results<ProductTable> {
//        let data = realm.objects(ProductTable.self)
//        
//        return data
//    }
//    
//    func createItem() {
//        do {
//            try realm.write {
//                
//                let data = ProductTable(id: ["린스", "커피", "과자", "칼국수"].randomElement()!, itemImage: ["린스", "커피", "과자", "칼국수"].randomElement()!, mallName: ["린스", "커피", "과자", "칼국수"].randomElement()!, title: ["린스", "커피", "과자", "칼국수"].randomElement()!, lprice: ["린스", "커피", "과자", "칼국수"].randomElement()!, productlike: true)
//                
//                realm.add(data)
//                
//                print("realm 저장완료")
//            }
//        } catch {
//            // realm 에 저장을 실패한 경우
//            print("realm 에 저장 실패!")
//        }
//    }
//    
//    func createItemInFolder(folder: Folder) {
//        do {
//            try realm.write {
//                
//                // 어떤 폴더에 넣어줄 지
////                let folder = realm.objects(Folder.self).where {
////                    $0.name == "개인"
////                }.first!
//                
//                let data = ProductTable(id: ["린스", "커피", "과자", "칼국수"].randomElement()!, itemImage: ["린스", "커피", "과자", "칼국수"].randomElement()!, mallName: ["린스", "커피", "과자", "칼국수"].randomElement()!, title: ["린스", "커피", "과자", "칼국수"].randomElement()!, lprice: ["린스", "커피", "과자", "칼국수"].randomElement()!, productlike: true)
//                
//                folder.detail.append(data)
//                
//                print("realm 저장완료")
//            }
//        } catch {
//            // realm 에 저장을 실패한 경우
//            print("realm 에 저장 실패!")
//        }
//    }
//    
//    func deleteItem(data: ProductTable) {
//        do {
//            try realm.write {
//        
//                realm.delete(data)
//            }
//        } catch {
//            print("realm 데이터 삭제 실패")
//        }
//    }
//    
//    func updateItem(data: ProductTable) {
//        
//    }
//    
//}
