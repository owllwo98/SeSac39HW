//
//  Folder.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/5/25.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted var id: ObjectId
    @Persisted var name: String
    
    @Persisted var detail: List<TravelTable>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
