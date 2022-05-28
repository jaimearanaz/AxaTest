//
//  FilterActive.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

struct Filter {
    
    var age: ClosedRange<Int> = 0...0
    var weight: ClosedRange<Int> = 0...0
    var height: ClosedRange<Int> = 0...0
    var hairColor = [String]()
    var profession = [String]()
}
