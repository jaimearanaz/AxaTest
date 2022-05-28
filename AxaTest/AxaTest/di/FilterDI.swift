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
        let getActiveFilterUseCase = DefaultGetActiveFilterUseCase(nonPersistentRepository: nonPersistentRepository)
        let saveActiveFilterUseCase = DefaultSaveActiveFilterUseCase(nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultFilterViewModel(getFilterValuesUseCase: getFilterValuesUseCase,
                                               getActiveFilterUseCase: getActiveFilterUseCase,
                                               saveActiveFilterUserCase: saveActiveFilterUseCase)
        
        let viewController = segue.destination as! FilterViewController
        viewController.viewModel = viewModel
    }
}
