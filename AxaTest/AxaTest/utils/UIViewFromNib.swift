//
//  UIViewFromNib.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation
import UIKit

class UIViewLoadableFromNib: UIView {
    
    @IBOutlet var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func nibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }

    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
