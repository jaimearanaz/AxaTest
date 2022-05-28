//
//  SaveSelectedCharacterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol SaveSelectedCharacterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(id: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

class DefaultSaveSelectedCharacterUseCase: SaveSelectedCharacterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(id: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        nonPersistentRepository.saveSelectedCharacter(id: id)
        completion(.success(true))
    }
}
