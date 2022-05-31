//
//  CharacterDetailsRouter.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation
import UIKit

protocol CharacterDetailsNavigationFlow {
    
    func injectCharacterDetails(withSegue segue: UIStoryboardSegue)
}

extension CharacterDetailsViewController {
    
    func route(transitionTo: CharacterDetailsTransitions) {
        
        switch transitionTo {
        case .toGrid:
            navigationController?.popToRootViewController(animated: true)
        default:
            self.performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch (segue.identifier) {
            
        case CharacterDetailsTransitions.toFriend.rawValue:
            navigationFlow?.injectCharacterDetails(withSegue: segue)
        default:
            break
        }
    }
}
