//
//  FilterDI.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit

extension DependencyInjector {
    
    func injectFilter(withSegue segue: UIStoryboardSegue) {

        let getFilterValuesUseCase = DefaultGetFilterValuesUseCase(nonPersistentRepository: nonPersistentRepository)
        let getFilterActiveUseCase = DefaultGetFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
        let saveFilterActiveUseCase = DefaultSaveFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultFilterViewModel(getFilterValuesUseCase: getFilterValuesUseCase,
                                               getFilterActiveUseCase: getFilterActiveUseCase,
                                               saveFilterActiveUserCase: saveFilterActiveUseCase)
        
        let viewController = segue.destination as! FilterViewController
        viewController.viewModel = viewModel
    }
}
