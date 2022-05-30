//
//  GridViewCell.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 30/5/22.
//

import Foundation
import UIKit

class GridViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: GridViewCell.self)
    
    @IBOutlet weak var shadowView: UIViewShadowable!
    @IBOutlet weak var imageView: UIImageViewRounded!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var surname: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        firstName.font = UIFont.bold(withSize: 14)
        surname.font = UIFont.bold(withSize: 12)
    }
}
