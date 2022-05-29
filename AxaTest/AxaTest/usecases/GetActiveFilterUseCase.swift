//
//  GetFilterActiveUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilterActiveUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void)
}

class DefaultGetFilterActiveUseCase: GetFilterActiveUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void) {
        
        if let filterActive = nonPersistentRepository.getFilterActive() {
            completion(.success(filterActive))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
