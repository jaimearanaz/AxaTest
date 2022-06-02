//
//  UIFont+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 30/5/22.
//

import Foundation
import UIKit

extension UIFont {
    
    private static let regularName = "Lato-Regular"
    private static let boldName = "Lato-Bold"
    private static let blackName = "Lato-Black"
    private static let specialName = "BlackCastleMF"
    
    static func regular(withSize size: CGFloat) -> UIFont {
        return UIFont(name: regularName, size: size)!
    }
    
    static func regular_16() -> UIFont {
        return regular(withSize: 16)
    }
    
    static func regular_18() -> UIFont {
        return regular(withSize: 18)
    }
 
    static func bold(withSize size: CGFloat) -> UIFont {
        return UIFont(name: boldName, size: size)!
    }
    
    static func bold_12() -> UIFont {
        return bold(withSize: 12)
    }
    
    static func bold_14() -> UIFont {
        return bold(withSize: 14)
    }

    static func black(withSize size: CGFloat) -> UIFont {
        return UIFont(name: blackName, size: size)!
    }
    
    static func black_16() -> UIFont {
        return black(withSize: 16)
    }
    
    static func black_18() -> UIFont {
        return black(withSize: 18)
    }
    
    static func special(withSize size: CGFloat) -> UIFont {
        return UIFont(name: specialName, size: size)!
    }

    static func special_20() -> UIFont {
        return special(withSize: 20)
    }
    
    static func special_22() -> UIFont {
        return special(withSize: 22)
    }

}
