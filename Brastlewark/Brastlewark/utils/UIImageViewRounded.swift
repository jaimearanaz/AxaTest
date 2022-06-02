//
//  UIImageViewRounded.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 30/5/22.
//

import Foundation
import UIKit

class UIImageViewRounded: UIImageView {
            
    override func layoutSubviews() {
        
        layer.masksToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
}
