//
//  UIViewShadowable.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 30/5/22.
//

import Foundation
import UIKit

class UIViewShadowable: UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
    }
}
