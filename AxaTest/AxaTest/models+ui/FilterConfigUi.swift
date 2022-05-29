//
//  FilterConfigUi.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 29/5/22.
//

import Foundation

struct FilterUi {
    
    var age: ClosedRange<Int> = 0...0
    var weight: ClosedRange<Int> = 0...0
    var height: ClosedRange<Int> = 0...0
    var hairColor = [String]()
    var profession = [String]()
}

struct FilterConfigUi {
    
    var filterValues: FilterUi
    var filterActive: FilterUi
}
