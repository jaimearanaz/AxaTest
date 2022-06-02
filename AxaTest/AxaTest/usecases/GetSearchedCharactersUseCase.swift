//
//  GetSearchedCharactersUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 2/6/22.
//

import Foundation

protocol GetSearchedCharactersUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase { get set }
    
    func execute(search: String) async throws -> [Character]
}

class DefaultGetSearchedCharactersUseCase: GetSearchedCharactersUseCase {

    var cachedRepository: CachedRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase
    
    init(cachedRepository: CachedRepositoryProtocol,
         nonPersistentRepository: NonPersistentRepositoryProtocol,
         getFilteredCharactersUseCase: GetFilteredCharactersUseCase) {
        
        self.cachedRepository = cachedRepository
        self.nonPersistentRepository = nonPersistentRepository
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
    }
    
    func execute(search: String) async throws -> [Character] {
        
        do {
            let characters = try await getFilteredCharactersUseCase.execute()
            return searchCharacters(characters, ByNameOrProfession: search)
        } catch let error {
            throw error
        }
    }

    private func searchCharacters(_ characters: [Character], ByNameOrProfession nameOrProfession: String) -> [Character] {

        return characters
            .filter {
                $0.name.uppercased().contains(nameOrProfession.uppercased()) ||
                $0.professions.map{ $0.uppercased() }.containsOneOrMoreOfElements(in: [nameOrProfession.uppercased()])
            }
    }
}
