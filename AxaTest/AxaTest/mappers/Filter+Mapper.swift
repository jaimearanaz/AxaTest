//
//  Filter+Mapper.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 29/5/22.
//

import Foundation

extension Filter {
    
    func toFilterUi() -> FilterUi {
        return FilterUi(age: age,
                        weight: weight,
                        height: height,
                        hairColor: hairColor,
                        profession: profession,
                        friends: friends)
    }
}

extension FilterUi {
    
    func toFilter() -> Filter {
        return Filter(age: age,
                      weight: weight,
                      height: height,
                      hairColor: hairColor,
                      profession: profession,
                      friends: friends)
    }
}
