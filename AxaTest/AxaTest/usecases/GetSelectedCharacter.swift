//
//  GetSelectedCharacterUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetSelectedCharacterUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute() async throws -> Character
}

class DefaultGetSelectedCharacterUseCase: GetSelectedCharacterUseCase {

    var cachedRepository: CachedRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(cachedRepository: CachedRepositoryProtocol, nonPersistentRepository: NonPersistentRepositoryProtocol) {
        
        self.cachedRepository = cachedRepository
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute() async throws -> Character {

        if let id = nonPersistentRepository.getSelectedCharacter() {
            do {
                let characters = try await cachedRepository.getCharacters()
                if let oneCharacter = (characters.filter { $0.id == id }).first {
                    return oneCharacter
                } else {
                    throw NonPersistentErrors.noData
                }
            } catch let error {
                throw error
            }
        } else {
            throw NonPersistentErrors.noData
        }
    }
}
