//
//  RealmModel.swift
//  SeSac39HW
//
//  Created by 변정훈 on 3/4/25.
//

import Foundation
import RealmSwift


class ProductTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var itemImage: String?

    @Persisted var mallName: String?

    @Persisted(indexed: true) var title: String?
    
    @Persisted var lprice: String?
    
    @Persisted var productlike: Bool
    
    
    convenience init(itemImage: String?, mallName: String?, title: String?, lprice: String?, productlike: Bool) {
        self.init()
        self.itemImage = itemImage
        self.mallName = mallName
        self.title = title
        self.lprice = lprice
        self.productlike = productlike
    }
}
