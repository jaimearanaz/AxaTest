//
//  AvatarImageView.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation
import UIKit
import SDWebImage

class AvatarImageView: UIViewLoadableFromNib {
    
    @IBOutlet weak var imageView: UIImageViewRounded!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nibSetup()
    }
    
    func setImage(withUrl url: URL) {
        imageView.sd_setImage(with: url)
    }
}
