//
//  City.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

struct City: Codable {
    
    var brastlewark: [Character]
    
    enum CodingKeys: String, CodingKey {
        case brastlewark = "Brastlewark"
    }
}
