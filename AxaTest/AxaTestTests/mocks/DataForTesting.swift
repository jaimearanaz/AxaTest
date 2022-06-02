//
//  CharactersForTesting.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 2/6/22.
//

import Foundation
@testable import AxaTest

struct DataForTesting {
    
    static let CharactersJSONfile = "characters_for_testing"
    
    static let HairValues =  ["Black", "White", "Pink"]
    static let ProfessionValues = ["Carpenter", "Miner", "Wizard"]
    static let WideRange = 0...1000
    
    static let FilterValues = Filter(age: 3...10,
                                     weight: 34...82,
                                     height: 65...125,
                                     hairColor: DataForTesting.HairValues,
                                     profession: DataForTesting.ProfessionValues,
                                     friends: 0...4)
    static let Characters = [
        
        Character(id: 0,
                  name: "Kinthony Tinkrivet",
                  thumbnail: "http://www.publicdomainpictures.net/pictures/120000/velka/cactus-1430656432Iug.jpg",
                  age: 3,
                  weight: 34,
                  height: 123,
                  hairColor: "Black",
                  professions: ["Miner"],
                  friends: ["Sarabink Wrongwhistle"]),
        
        Character(id: 1,
                  name: "Malbin Gimballauncher",
                  thumbnail: "http://www.publicdomainpictures.net/pictures/20000/velka/squirrel-in-winter-11298746828jAB.jpg",
                  age: 5,
                  weight: 54,
                  height: 125,
                  hairColor: "White",
                  professions: ["Carpenter"],
                  friends: ["Kinthony Tinkrivet", "Fizwood Chillbuster"]),
        
        Character(id: 2,
                  name: "Fizwood Chillbuster",
                  thumbnail: "http://www.publicdomainpictures.net/pictures/10000/nahled/1-1275897675Dsss.jpg",
                  age: 6,
                  weight: 35,
                  height: 97,
                  hairColor: "Pink",
                  professions: ["Wizard"],
                  friends: ["Malbin Gimballauncher", "Whitwright Switchslicer"]),
        
        Character(id: 3,
                  name: "Whitwright Switchslicer",
                  thumbnail: "http://www.publicdomainpictures.net/pictures/20000/velka/squirrel-in-winter-11298746828jAB.jpg",
                  age: 7,
                  weight: 65,
                  height: 98,
                  hairColor: "Black",
                  professions: ["Carpenter"],
                  friends: [String]()),
        
        Character(id: 4,
                  name: "Sarabink Wrongwhistle",
                  thumbnail: "http://www.publicdomainpictures.net/pictures/20000/nahled/sunset-in-winter.jpg",
                  age: 10,
                  weight: 82,
                  height: 65,
                  hairColor: "Black",
                  professions: ["Carpenter"],
                  friends: ["Fizwood Chillbuster", "Whitwright Switchslicer", "Malbin Gimballauncher", "Kinthony Tinkrivet"])
    ]
}
