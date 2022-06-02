//
//  GetFilterActiveUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilterActiveUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute() async throws -> Filter
}

class DefaultGetFilterActiveUseCase: GetFilterActiveUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute() async throws -> Filter {
        if let filterActive = nonPersistentRepository.getFilterActive() {
            return filterActive
        } else {
            throw NonPersistentErrors.noData
        }
    }
}
