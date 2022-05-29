//
//  GetCharacterByIdUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 29/5/22.
//

import Foundation

protocol GetCharacterByIdUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(id: Int, completion: @escaping (Result<Character, Error>) -> Void)
}

class DefaultGetCharacterByIdUseCase: GetCharacterByIdUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        
        let characters = nonPersistentRepository.getSavedCharacters()
        if let oneCharacter = (characters.filter { $0.id == id }).first {
            completion(.success(oneCharacter))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
