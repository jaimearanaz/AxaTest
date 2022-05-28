//
//  GetCharactersUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import Combine

protocol GetCharactersUseCase {
    
    var networkRepository: NetworkRepositoryProtocol { get set }
    var nonPersistentRepository: NonPersistentRepositoryProtocol { get set }
    
    func execute(completion: @escaping (Result<[Character], Error>) -> Void)
}

class DefaultGetCharactersUseCase: GetCharactersUseCase {

    var networkRepository: NetworkRepositoryProtocol
    var nonPersistentRepository: NonPersistentRepositoryProtocol
    private var subscribers = Set<AnyCancellable>()
    
    init(networkRepository: NetworkRepositoryProtocol, nonPersistentRepository: NonPersistentRepositoryProtocol) {
        self.networkRepository = networkRepository
        self.nonPersistentRepository = nonPersistentRepository
    }
    
    func execute(completion: @escaping (Result<[Character], Error>) -> Void) {

        let savedCharacters = nonPersistentRepository.getSavedCharacters()
        
        if savedCharacters.isEmpty {
            
            networkRepository.getCharacters()
                .sink { combineCompletion in
                    
                    switch combineCompletion {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                } receiveValue: { characters in

                    self.nonPersistentRepository.saveCharacters(characters)
                    let filterValues = self.getFilterValues(fromCharacters: characters)
                    self.nonPersistentRepository.saveFilterValues(filterValues)
                    self.nonPersistentRepository.saveActiveFilter(filterValues)
                    completion(.success(characters))
                }
                .store(in: &subscribers)

        } else {
            completion(.success(savedCharacters))
        }
    }
    
    private func getFilterValues(fromCharacters characters: [Character]) -> Filter {
        
        var professions = Set<String>()
        var hairColors = Set<String>()
        
        characters.forEach ({
            $0.professions.forEach { professions.insert($0) }
            hairColors.insert($0.hairColor)
        })
        
        let minAge = characters.min { $0.age < $1.age }?.age ?? 0
        let maxAge = characters.max { $0.age < $1.age }?.age ?? 0
        let minWeight = Int(characters.min { $0.weight < $1.weight }?.weight ?? 0)
        let maxWeight = Int(characters.max { $0.weight < $1.weight }?.weight ?? 0)
        let minHeight = Int(characters.min { $0.height < $1.height }?.height ?? 0)
        let maxHeight = Int(characters.max { $0.height < $1.height }?.height ?? 0)
        
        return Filter(age: minAge...maxAge,
                      weight: minWeight...maxWeight,
                      height: minHeight...maxHeight,
                      hairColor: Array(hairColors),
                      profession: Array(professions))
    }
}
