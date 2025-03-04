//
//  Shopping.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/25/25.
//

import Foundation

struct Shopping: Decodable {
    var items: [ShoppingDetail]
    let total: Int?
}

struct ShoppingDetail: Decodable {
//    let title: String?
//    let image: String?
//    let lprice: String?
//    let mallName: String?
    
    let title: String?
    let link: String?
    let image: String?
    let lprice, hprice, mallName: String?
    let productId: String
    let productType: String?
    let brand, maker: String?
    let category1: String?
    let category2: String?
    let category3: String?
    let category4: String?
}
