//
//  CharacterDI.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit

extension DependencyInjector {
    
    func injectCharacter(withSegue segue: UIStoryboardSegue) {
        
        let getSelectedCharacterUseCase = DefaultGetSelectedCharacterUseCase(nonPersistentRepository: nonPersistentRepository)
        let getCharacterByIdUseCase = DefaultGetCharacterByIdUseCase(nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultCharacterDetailsViewModel(getSelectedCharacterUseCase: getSelectedCharacterUseCase,
                                                         getCharacterByIdUseCase: getCharacterByIdUseCase)
        
        let viewController = segue.destination as! CharacterDetailsViewController
        viewController.viewModel = viewModel
    }
}
