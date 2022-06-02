//
//  ResetFilterActiveUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol ResetFilterActiveUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute() async throws -> Void
}

class DefaultResetFilterActiveUseCase: ResetFilterActiveUseCase {

    var cachedRepository: CachedRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(cachedRepository: CachedRepositoryProtocol, nonPersistentRepository: NonPersistentRepositoryProtocol) {
        
        self.cachedRepository = cachedRepository
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute() async throws -> Void {
        
        do {
            let filterValues = try await cachedRepository.getFilterValues()
            nonPersistentRepository.saveFilterActive(filterValues)
            return
        } catch let error {
            throw error
        }
    }
}
