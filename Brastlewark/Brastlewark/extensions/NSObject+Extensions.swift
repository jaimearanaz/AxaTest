//
//  NSObject+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation

extension NSObject {

    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
