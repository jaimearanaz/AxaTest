//
//  UIFont+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 30/5/22.
//

import Foundation
import UIKit

extension UIFont {
    
    static func regular(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Regular", size: size)!
    }
    
    static func bold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size)!
    }

    static func black(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Black", size: size)!
    }
    
    static func castle(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "BlackCastleMF", size: size)!
    }
}
