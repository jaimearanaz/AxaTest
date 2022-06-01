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
            viewController.identifier = FilterOptionsType.hair
            
        case FilterTransitions.toFilterProfession.rawValue:
            let viewController = segue.destination as! FilterOptionsViewController
            let professionsOptions = getFilterOptionForProfessions()
            viewController.setItems(professionsOptions)
            viewController.delegate = self
            viewController.identifier = FilterOptionsType.professions
            
        default:
            break
        }
    }
}
