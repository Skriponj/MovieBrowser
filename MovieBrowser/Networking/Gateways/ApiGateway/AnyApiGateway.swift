//
//  AnyApiGateway.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import Foundation

protocol AnyApiGateway {
    var apiClient: ApiClient { get set }
    
    init(apiClient: ApiClient)
}
