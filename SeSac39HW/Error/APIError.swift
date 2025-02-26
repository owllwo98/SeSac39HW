//
//  APIError.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/26/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(String)
    case statusError(Int)
    case serverError(APIErrorResponse)
    case dataNotFound
    case decodingError(String)
    case unknownResponse
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL 요청입니다."
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .statusError(let code):
            return "서버 오류 (HTTP 상태 코드: \(code))"
        case .serverError(let errorResponse):
            return "서버 오류: \(errorResponse.errorMessage) (\(errorResponse.errorCode))"
        case .dataNotFound:
            return "데이터를 찾을 수 없습니다."
        case .decodingError(let message):
            return "데이터 디코딩 실패: \(message)"
        case .unknownResponse:
            return "알 수 없는 응답입니다."
        }
    }
}
