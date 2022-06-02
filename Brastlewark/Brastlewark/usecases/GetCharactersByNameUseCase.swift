//
//  GetCharactersByNameUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 31/5/22.
//

import Foundation

protocol GetCharactersByNameUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(names: [String]) async throws -> [Character]
}

class DefaultGetCharactersByNameUseCase: GetCharactersByNameUseCase {
    
    var cachedRepository: CachedRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(cachedRepository: CachedRepositoryProtocol, nonPersistentRepository: NonPersistentRepositoryProtocol) {
        
        self.cachedRepository = cachedRepository
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(names: [String]) async throws -> [Character] {
        
        do {
            let characters = try await cachedRepository.getCharacters()
            let filteredCharacters = characters.filter { names.contains($0.name) }
            return filteredCharacters
        } catch let error {
            throw error
        }
        
    }
}
