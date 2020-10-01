//
//  ImageCacheKey.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

class ImageCacheKey {
    
    private let value: Int
    
    var key: String {
        return "movie/\(value)/poster"
    }
    
    init(value: Int) {
        self.value = value
    }
}
