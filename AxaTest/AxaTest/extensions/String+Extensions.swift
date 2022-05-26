//
//  String+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
