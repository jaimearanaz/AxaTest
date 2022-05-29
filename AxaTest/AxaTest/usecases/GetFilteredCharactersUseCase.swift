//
//  GetFilteredCharactersUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilteredCharactersUseCase {
    
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<[Character], Error>) -> Void)
}

class DefaultGetFilteredCharactersUseCase: GetFilteredCharactersUseCase {

    var nonPersistentRepository: NonPersistentRepositoryProtocol
    
    init(nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<[Character], Error>) -> Void) {

        let characters = nonPersistentRepository.getSavedCharacters()
        let filterActive = nonPersistentRepository.getFilterActive()
        
        if let filterActive = filterActive, characters.isNotEmpty {
            let filtered = filterCharacters(characters, withFilter: filterActive)
            completion(.success(filtered))
        } else {
            completion(.failure(NonPersistentErrors.noData))
        }
    }
    
    private func filterCharacters(_ characters: [Character], withFilter filter: Filter) -> [Character] {

        return characters
            .filter { filter.age.contains($0.age) }
            .filter { filter.weight.contains(Int($0.weight)) }
            .filter { filter.height.contains(Int($0.height)) }
            .filter { filter.hairColor.contains($0.hairColor) }
            .filter { filter.profession.containsOneOrMoreOfElements(in: $0.professions) }
    }
}
