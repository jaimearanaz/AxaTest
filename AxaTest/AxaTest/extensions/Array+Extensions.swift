//
//  Array+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension Array where Element: Any & Hashable {
    
    func containsOneOrMoreOfElements(in array: [Element]) -> Bool {
        
        let firstSet = Set(self)
        let secondSet = Set(array)
        let inBoth = firstSet.intersection(secondSet)
        return inBoth.isNotEmpty
    }
}
