//
//  GetFilterValuesUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilterValuesUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void)
}

class DefaultGetFilterValuesUseCase: GetFilterValuesUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Filter, Error>) -> Void) {
        
        if let filterValues = nonPersistentRepository.getFilterValues() {
            completion(.success(filterValues))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
