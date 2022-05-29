//
//  GetSelectedCharacterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetSelectedCharacterUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<Character, Error>) -> Void)
}

class DefaultGetSelectedCharacterUseCase: GetSelectedCharacterUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<Character, Error>) -> Void) {
        
        if let id = nonPersistentRepository.getSelectedCharacter() {
            
            let characters = nonPersistentRepository.getSavedCharacters()
            if let oneCharacter = (characters.filter { $0.id == id }).first {
                completion(.success(oneCharacter))
            } else {
                completion(.failure(NonPersistentErrors.noData))
            }
            
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
}
