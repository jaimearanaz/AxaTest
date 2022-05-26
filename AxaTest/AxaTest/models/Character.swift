//
//  Character.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

struct Character: Codable {
    
    var id: Int
    var name: String
    var thumbnail: String
    var age: Int
    var weight: Double
    var height: Double
    var hairColor: String
    var professions: [String]
    var friends: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case thumbnail
        case age
        case weight
        case height
        case hairColor = "hair_color"
        case professions
        case friends
    }
}
