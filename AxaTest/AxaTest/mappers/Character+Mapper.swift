//
//  Character+Mapper.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension Character {
    
    func toCharacterGridUi() -> CharacterGridUi {
        return CharacterGridUi(id: id, name: name, thumbnail: thumbnail, age: age)
    }
    
    func toCharacterDetailsUi() -> CharacterDetailsUi {
        return CharacterDetailsUi(id: id,
                                  name: name,
                                  thumbnail: thumbnail,
                                  age: age,
                                  weight: weight,
                                  height: height,
                                  hairColor: hairColor,
                                  professions: professions,
                                  friends: friends)
    }
}
