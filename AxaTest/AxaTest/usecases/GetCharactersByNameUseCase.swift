//
//  GetCharactersByNameUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation

protocol GetCharactersByNameUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(names: [String], completion: @escaping (Result<[Character], Error>) -> Void)
}

class DefaultGetCharactersByNameUseCase: GetCharactersByNameUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(names: [String], completion: @escaping (Result<[Character], Error>) -> Void) {
        
        let characters = nonPersistentRepository.getSavedCharacters()
        if characters.isNotEmpty {
            let filteredCharacters = characters.filter { names.contains($0.name) }
            completion(.success(filteredCharacters))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
