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
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        age = try values.decode(Int.self, forKey: .age)
        weight = try values.decode(Double.self, forKey: .weight)
        height = try values.decode(Double.self, forKey: .height)
        hairColor = try values.decode(String.self, forKey: .hairColor)
        professions = try values.decode([String].self, forKey: .professions)
        if professions.isEmpty {
            professions.append("PROFESSION_NONE".localized)
        }
        friends = try values.decode([String].self, forKey: .friends)
    }
}
