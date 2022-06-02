//
//  GridDI.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension DependencyInjector {
    
    func injectGrid(viewController: GridViewController) {
        
        let networkRepository = NetworkRepository(baseUrl: APIBaseURL.rawValue, networkStatus: NetworkStatus.self)
        let cachedRepository = CachedRepository(networkRepository: networkRepository, nonPersistentRepository: nonPersistentRepository, useCache: true)
        let getCharactersUseCase = DefaultGetCharactersUseCase(repository: cachedRepository)
        let getFilterActiveUseCase = DefaultGetFilterActiveUseCase(nonPersistentRepository: nonPersistentRepository)
        let getFilterValuesUseCase = DefaultGetFilterValuesUseCase(cachedRepository: cachedRepository)
        let getFilteredCharactersUseCase = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let resetFilterActiveUseCase = DefaultResetFilterActiveUseCase(cachedRepository: cachedRepository, nonPersistentRepository: nonPersistentRepository)
        let saveSelectedCharacter = DefaultSaveSelectedCharacterUseCase(nonPersistentRepository: nonPersistentRepository)
        let invalidateCachedData = DefaultInvalidateCachedDataUseCase(nonPersistentRepository: nonPersistentRepository)
        let viewModel = DefaultGridViewModel(getCharactersUseCase: getCharactersUseCase,
                                             getFilterActiveUseCase: getFilterActiveUseCase,
                                             getFilterValuesUseCase: getFilterValuesUseCase,
                                             getFilteredCharactersUseCase: getFilteredCharactersUseCase,
                                             resetFilterActiveUserCase: resetFilterActiveUseCase,
                                             saveSelectedCharacter: saveSelectedCharacter,
                                             invalidateCachedData: invalidateCachedData)
        
        viewController.viewModel = viewModel
        viewController.navigationFlow = self
    }
}
