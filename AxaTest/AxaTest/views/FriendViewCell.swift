//
//  FriendViewCell.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation
import UIKit
import SDWebImage

class FriendViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: GridViewCell.self)
    static let cellHeight: CGFloat = 60
    
    @IBOutlet weak var friendImageView: UIImageViewRounded!
    @IBOutlet weak var firstnameLb: UILabel!
    @IBOutlet weak var surnameLb: UILabel!
    
    override func draw(_ rect: CGRect) {
        
        firstnameLb.font = UIFont.bold(withSize: 14)
        surnameLb.font = UIFont.bold(withSize: 12)
    }
    
    func setupCell(friend: FriendUi) {
        
        if let url = URL(string: friend.thumbnail) {
            friendImageView.sd_setImage(with: url) { (image, error, cache, url) in
                self.friendImageView.image = image
                self.friendImageView.setNeedsLayout()
                self.friendImageView.layoutSubviews()
            }
        }
        firstnameLb.text = friend.name.firstname()
        surnameLb.text = friend.name.surname()
    }
}
