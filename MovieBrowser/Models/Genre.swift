//
//  Genre.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import Foundation

class Genre: NSObject, Decodable, NSCoding {
    
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        id = coder.decodeObject(forKey: "id") as? Int ?? 0
        name = coder.decodeObject(forKey: "name") as? String ?? ""
    }
}
