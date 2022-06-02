//
//  GetFilteredCharactersUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilteredCharactersUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute() async throws -> [Character]
}

class DefaultGetFilteredCharactersUseCase: GetFilteredCharactersUseCase {

    var cachedRepository: CachedRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(cachedRepository: CachedRepositoryProtocol, nonPersistentRepository: NonPersistentRepositoryProtocol) {
        
        self.cachedRepository = cachedRepository
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute() async throws -> [Character] {
        
        do {
            let characters = try await cachedRepository.getCharacters()
            if let filterActive = nonPersistentRepository.getFilterActive() {
                return filterCharacters(characters, withFilter: filterActive)
            } else {
                throw NonPersistentErrors.noData
            }
        } catch let error {
            throw error
        }
    }

    private func filterCharacters(_ characters: [Character], withFilter filter: Filter) -> [Character] {

        return characters
            .filter { filter.age.contains($0.age) }
            .filter { filter.weight.contains(Int($0.weight)) }
            .filter { filter.height.contains(Int($0.height)) }
            .filter { filter.hairColor.contains($0.hairColor) }
            .filter { filter.profession.map{ $0.uppercased() }.containsOneOrMoreOfElements(in: $0.professions.map{ $0.uppercased() }) }
            .filter { filter.friends.contains($0.friends.count) }
    }
}
