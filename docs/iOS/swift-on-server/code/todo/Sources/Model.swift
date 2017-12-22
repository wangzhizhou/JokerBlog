//
//  Model.swift
//  LoggerAPI
//
//  Created by JokerAtBaoFeng on 2017/9/13.
//

import Foundation
import SwiftyJSON

enum ItemError: String, Error {
    case malformatJSON
}

struct Item{
    let id: UUID
    let title: String
    
    init(json:JSON) throws {
        guard
            let d = json.dictionary,
            let title = d["title"]?.string
            else {
                throw ItemError.malformatJSON
        }
        
        self.id = UUID()
        self.title = title
    }
    
    var json: JSON {
        return JSON(["id": self.id.uuidString as Any, "title": self.title as Any])
    }
}
