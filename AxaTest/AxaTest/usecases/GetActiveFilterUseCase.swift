//
//  GetActiveFilterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetActiveFilterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void)
}

class DefaultGetActiveFilterUseCase: GetActiveFilterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void) {
        
        if let activeFilter = nonPersistentRepository.getActiveFilter() {
            completion(.success(activeFilter))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
