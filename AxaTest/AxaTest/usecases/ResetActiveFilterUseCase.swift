//
//  ResetActiveFilterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol ResetActiveFilterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void)
}

class DefaultResetActiveFilterUseCase: ResetActiveFilterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        
        if let filterValues = nonPersistentRepository.getFilterValues() {
            nonPersistentRepository.saveActiveFilter(filterValues)
            completion(.success(Void()))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
