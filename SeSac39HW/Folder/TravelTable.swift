//
//  TravelTable.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/5/25.
//


import Foundation
import RealmSwift


class TravelTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var city: String
    
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<Folder>
    
    convenience init(city: String) {
        self.init()
        self.city = city
    }
}
