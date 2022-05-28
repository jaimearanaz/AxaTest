//
//  SaveActiveFilterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol SaveActiveFilterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(filter: Filter, completion: @escaping (Result<Bool, Error>) -> Void)
}

class DefaultSaveActiveFilterUseCase: SaveActiveFilterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(filter: Filter, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        nonPersistentRepository.saveActiveFilter(filter)
        completion(.success(true))
    }
}
