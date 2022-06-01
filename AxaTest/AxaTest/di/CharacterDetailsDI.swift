//
//  CharacterDI.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit

extension DependencyInjector {
    
    func injectCharacterDetails(withSegue segue: UIStoryboardSegue) {
        
        let networkRepository = NetworkRepository(baseUrl: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
        let cachedRepository = CachedRepository(networkRepository: networkRepository, nonPersistentRepository: nonPersistentRepository, useCache: true)
        let getSelectedCharacterUseCase = DefaultGetSelectedCharacterUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let saveSelectedCharacterUseCase = DefaultSaveSelectedCharacterUseCase(nonPersistentRepository: nonPersistentRepository)
        let getCharactersByNameUseCase = DefaultGetCharactersByNameUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultCharacterDetailsViewModel(getSelectedCharacterUseCase: getSelectedCharacterUseCase,
                                                         saveSelectCharacterUseCase: saveSelectedCharacterUseCase,
                                                         getCharactersByNameUseCase: getCharactersByNameUseCase)
        
        let viewController = segue.destination as! CharacterDetailsViewController
        viewController.viewModel = viewModel
        viewController.navigationFlow = self
    }
}
