//
//  APIErrorResponse.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/26/25.
//

import Foundation

struct APIErrorResponse: Decodable {
    let errorMessage: String
    let errorCode: String
}
