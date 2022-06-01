//
//  GridDI.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension DependencyInjector {
    
    func injectGrid(viewController: GridViewController) {
        
        let networkRepository = NetworkRepository(baseUrl: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
        let cachedRepository = CachedRepository(networkRepository: networkRepository, nonPersistentRepository: nonPersistentRepository, useCache: true)
        let getCharactersUseCase = DefaultGetCharactersUseCase(repository: cachedRepository)
        let getFilterActiveUseCase = DefaultGetFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
        let getFilteredCharactersUseCase = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let resetFilterActiveUseCase = DefaultResetFilterActiveUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let saveSelectedCharacter = DefaultSaveSelectedCharacterUseCase(nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultGridViewModel(getCharactersUseCase: getCharactersUseCase,
                                             getFilterActiveUseCase: getFilterActiveUseCase,
                                             getFilteredCharactersUseCase: getFilteredCharactersUseCase,
                                             resetFilterActiveUserCase: resetFilterActiveUseCase,
                                             saveSelectedCharacter: saveSelectedCharacter)
        
        viewController.viewModel = viewModel
        viewController.navigationFlow = self
    }
}
