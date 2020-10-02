//
//  Trailer.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

class Trailer: NSObject, Decodable, NSCoding {
    var id: String
    var key: String
    var name: String
    
    init(id: String, key: String, name: String) {
        self.id = id
        self.key = key
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? String ?? ""
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        key = coder.decodeObject(forKey: "key") as? String ?? ""
    }
}
