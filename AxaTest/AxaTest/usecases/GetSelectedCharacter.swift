//
//  GetSelectedCharacterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetSelectedCharacterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Int, Error>) -> Void)
}

class DefaultGetSelectedCharacterUseCase: GetSelectedCharacterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Int, Error>) -> Void) {
        
        if let id = nonPersistentRepository.getSelectedCharacter() {
            completion(.success(id))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
