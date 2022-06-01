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
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}
