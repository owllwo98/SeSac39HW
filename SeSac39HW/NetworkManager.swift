//
//  NetworkManager.swift
//  SeSac39HW
//
//  Created by 변정훈 on 2/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func requestShoppingData(query: String, start: Int, sort: String) -> Single<Result<Shopping, APIError>> {
        
        return Single<Result<Shopping, APIError>>.create { value in
            
            let urlString =  URLValue.naver + "query=\(query)&start=\(start)&sort=\(sort)"
            
            guard let url = URL(string: urlString) else {
                
                value(.success(.failure(.invalidURL)))
                return Disposables.create {
                    print("끝!")
                }
            }
            
            var request = URLRequest(url: url)
            request.addValue(APIKey.naverID, forHTTPHeaderField: "X-Naver-Client-Id")
            request.addValue(APIKey.naverSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
            
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    value(.success(.failure(.networkError(error.localizedDescription))))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    value(.success(.failure(.unknownResponse)))
                    return
                }
                
                guard (200...299).contains(response.statusCode) else {
                    if let data = data {
                        do {
                            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                            value(.success(.failure(.serverError(errorResponse))))
                        } catch {
                            value(.success(.failure(.statusError(response.statusCode))))
                        }
                    } else {
                        value(.success(.failure(.statusError(response.statusCode))))
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(Shopping.self, from: data)
                        value(.success(.success(result)))
                    } catch {
                        value(.success(.failure(.decodingError(error.localizedDescription))))
                    }
                } else {
                    value(.success(.failure(.dataNotFound)))
                }
            }.resume()
            
            return Disposables.create {
                print("끝!")
            }
        }
    }
    
}


