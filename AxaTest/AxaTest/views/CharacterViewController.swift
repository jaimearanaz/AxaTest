//
//  CharacterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit

class CharacterDetailsViewController: BaseViewController {
    
    @IBOutlet weak var seeFriendBt: UIButton!
    
    var viewModel: CharacterDetailsViewModel? { didSet { baseViewModel = viewModel } }
    
    override func binds() {
        
        super.binds()
        viewModel?.character.bind({ character in
            // show character in UI
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
    }
    
    @IBAction func didSelectFriend() {
        viewModel?.didSelectFriend(id: Int.random(in: 1..<2000))
    }
}
