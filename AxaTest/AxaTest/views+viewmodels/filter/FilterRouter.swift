//
//  FilterRouter.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation
import UIKit

extension FilterViewController {
    
    func route(transitionTo: FilterTransitions) {
        
        switch transitionTo {
        case .dismiss:
            navigationController?.popToRootViewController(animated: true)
        case .toFilterHair:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        case .toFilterProfession:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch (segue.identifier) {
            
        case FilterTransitions.toFilterHair.rawValue:
            let viewController = segue.destination as! FilterOptionsViewController
            let hairOptions = getFilterOptionForHairColors()
            viewController.setItems(hairOptions)
            viewController.delegate = self
            
        case FilterTransitions.toFilterProfession.rawValue:
            break
            
        default:
            break
        }
    }
}
