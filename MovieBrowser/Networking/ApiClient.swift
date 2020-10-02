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
    
    func execute(request: URLRequest, completion: @escaping (_ result: Result<Data?, ApiError>) -> Void)
}

struct RequestCache {
    var url: String
    var request: URLRequest
    var completion: ((Result<Data?, ApiError>) -> Void)
}

class AppApiClient: ApiClient {
    
    private var cachedRequests: [String: RequestCache]
    private let networkManager: NetworkManager
    private let session: Session
    var apiKey: String {
        return "87f9d2ee3108713aaf566baa9457e1d0"
    }
    
    init() {
        cachedRequests = [:]
        networkManager = NetworkManager.shared
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        session = Session(configuration: config)
        observeNetworkChanges()
    }
    
    func execute(request: URLRequest, completion: @escaping (Result<Data?, ApiError>) -> Void) {
        guard let url = request.url else {
            return
        }
        
        let _ = session.request(request).validate().response { [weak self] (response) in
            let result = response.result
            let statusCode = response.response?.statusCode
            
            switch result {
            case .success(let data):
                self?.cachedRequests.removeValue(forKey: url.absoluteString)
                
                guard let data = data else {
                    let errorType = ApiError.ErrorType.emptyData
                    completion(.failure(ApiError(statusCode: statusCode, message: errorType.rawValue)))
                    return
                }
                
                completion(.success(data))
                
            case .failure(let error):
                var apiError: ApiError
                if self?.isConnectionError(error: error.underlyingError) == true {
                    self?.cachedRequests[url.absoluteString] = RequestCache(url: url.absoluteString,
                                                                            request: request,
                                                                            completion: completion)
                    apiError = ApiError(statusCode: statusCode, message: "Internet connection appears to be offline")
                    completion(.failure(apiError))
                    return
                }
                apiError = ApiError(statusCode: statusCode, message: error.errorDescription)
                completion(.failure(apiError))
            }
        }
    }
    
    private func observeNetworkChanges() {
        let block: (NetworkReachabilityManager.NetworkReachabilityStatus) -> Void = { [weak self] status in
            switch status {
            case .reachable(_):
                self?.retryFailedRequests()
            default:
                break
            }
        }
        
        networkManager.observeNetworkStatus(block: block)
    }
    
    private func retryFailedRequests() {
        cachedRequests.values.forEach { (request) in
            execute(request: request.request, completion: request.completion)
        }
    }
    
    private func isConnectionError(error: Error?) -> Bool {
        guard let error = error else { return false }
        let underlyingError = error as NSError
        let code = Int32(underlyingError.code)
        if let networkError = CFNetworkErrors(rawValue: code) {
            switch networkError {
            case .cfErrorHTTPConnectionLost, .cfurlErrorNotConnectedToInternet, .cfurlErrorTimedOut:
                return true
            default:
                return false
            }
        }
        return false
    }
}
