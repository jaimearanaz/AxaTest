//
//  Character+Mapper.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension Character {
    
    func toCharacterGrid() -> CharacterGrid {
        return CharacterGrid(id: id, name: name, thumbnail: thumbnail, age: age)
    }
}
