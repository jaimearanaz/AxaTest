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
        let getCharactersUseCase = DefaultGetCharactersUseCase(networkRepository: networkRepository, nonPersistentRepository: nonPersistentRepository)
        let getFilterActiveUseCase = DefaultGetFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
        let getFilteredCharactersUseCase = DefaultGetFilteredCharactersUseCase(nonPersistentRepository: nonPersistentRepository)
        let resetFilterActiveUseCase = DefaultResetFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
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
