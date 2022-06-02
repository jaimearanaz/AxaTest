//
//  SaveFilterActiveUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol SaveFilterActiveUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(filter: Filter) async -> Void
}

class DefaultSaveFilterActiveUseCase: SaveFilterActiveUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(filter: Filter) async -> Void {
        
        nonPersistentRepository.saveFilterActive(filter)
        return
    }
}
