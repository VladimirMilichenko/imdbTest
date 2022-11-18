//
//  Top250DataModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let rank: String
    let imageUrlPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case rank
        case imageUrlPath = "image"
    }
}

struct Movies: Codable {
    let items: [Movie]
}
