//
//  CharacterName.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation

typealias CharacterName = String

extension CharacterName {
    
    func firstname() -> String {
        self.components(separatedBy: CharacterSet(charactersIn: " ")).first ?? ""
    }
    
    func surname() -> String {
        self.components(separatedBy: CharacterSet(charactersIn: " ")).last ?? ""
    }
}
