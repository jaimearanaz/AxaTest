//
//  InvalidateCachedDataUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation

protocol InvalidateCachedDataUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute() async -> Void
}

class DefaultInvalidateCachedDataUseCase: InvalidateCachedDataUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute() async -> Void {
        
        nonPersistentRepository.invalidateData()
        return
    }
}
