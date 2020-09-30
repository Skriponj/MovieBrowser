//
//  ApiClient.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation
import Alamofire

protocol ApiClient {
    var apiKey: String { get }
    
    func execute<T: Decodable>(request: URLRequest, completion: @escaping (_ result: Result<T, ApiError>) -> Void)
}

class AppApiClient: ApiClient {
    
    var apiKey: String {
        return "87f9d2ee3108713aaf566baa9457e1d0"
    }
    
    func execute<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        AF.request(request).validate().response { (response) in
            let result = response.result
            let statusCode = response.response?.statusCode
            
            switch result {
            case .success(let data):
                
                guard let data = data else {
                    let errorType = ApiError.ErrorType.emptyData
                    completion(.failure(ApiError(statusCode: statusCode, message: errorType.rawValue)))
                    return
                }
                
                do {
                    let model = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(model))
                } catch let error {
                    completion(.failure(ApiError(statusCode: statusCode, message: error.localizedDescription)))
                }
                
                
            case .failure(let error):
                let apiError = ApiError(statusCode: statusCode, message: error.errorDescription)
                completion(.failure(apiError))
            }
        }
    }
}
