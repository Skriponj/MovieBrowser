//
//  ApiError.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation

struct ApiError: Error {
    
    enum ErrorType: String {
        case unexpected = "We encountered a communication problem.\nIf the issue persist wait some time and try again later."
        case emptyData = "Server provides no data. Parsing error occured. Please try again later."
        case wrongRequest = "Invalid request.\nPlease try again later."
    }
    
    var statusCode: Int?
    var message: String?
    
    init(statusCode: Int? = nil, message: String?) {
        self.statusCode = statusCode
        self.message = message ?? ErrorType.unexpected.rawValue
    }
    
    static var wrongRequest: ApiError {
        return ApiError(statusCode: -1, message: ErrorType.wrongRequest.rawValue)
    }
}
