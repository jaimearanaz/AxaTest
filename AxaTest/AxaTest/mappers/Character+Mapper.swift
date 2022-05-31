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
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2

        return CharacterDetailsUi(id: id,
                                  name: name,
                                  thumbnail: thumbnail,
                                  age: age,
                                  weight: numberFormatter.string(from: NSNumber(value: weight)) ?? "",
                                  height: numberFormatter.string(from: NSNumber(value: height)) ?? "",
                                  hairColor: hairColor,
                                  professions: professions)
    }
    
    func toFriendUi() -> FriendUi {
        return FriendUi(id: id, name: name, thumbnail: thumbnail)
    }
}
