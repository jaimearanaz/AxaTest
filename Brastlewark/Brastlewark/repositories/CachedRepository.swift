//
//  CachedRepository.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation
import Combine

class CachedRepository: CachedRepositoryProtocol {

    private var networkRepository: NetworkRepositoryProtocol?
    private var nonPersistentRepository: NonPersistentRepositoryProtocol?
    private var useCache: Bool
    private var subscribers = Set<AnyCancellable>()

    init(networkRepository: NetworkRepositoryProtocol? = nil,
         nonPersistentRepository: NonPersistentRepositoryProtocol? = nil,
         useCache: Bool) {
        
        self.networkRepository = networkRepository
        self.nonPersistentRepository = nonPersistentRepository
        self.useCache = useCache
    }
    
    func getCharacters() async throws -> [Character] {
        
        if useCache {
            if let savedCharacters = nonPersistentRepository?.getSavedCharacters() {
                return savedCharacters
            }
        }
        
        do {
            return try await getAndSaveDataFromNetwork().characters
        } catch let error {
            throw error
        }
    }
    
    func getFilterValues() async throws -> Filter {
        
        if useCache {
            if let filterValues = nonPersistentRepository?.getFilterValues() {
                return filterValues
            }
        }
        
        do {
            return try await getAndSaveDataFromNetwork().filterValues
        } catch let error {
            throw error
        }
    }

    private func getAndSaveDataFromNetwork() async throws -> (characters: [Character], filterValues: Filter) {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            networkRepository?.getCharacters()
                .sink { combineCompletion in
                    
                    switch combineCompletion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    
                } receiveValue: { characters in

                    self.nonPersistentRepository?.saveCharacters(characters)
                    let filterValues = self.getFilterValues(fromCharacters: characters)
                    self.nonPersistentRepository?.saveFilterValues(filterValues)
                    self.nonPersistentRepository?.saveFilterActive(filterValues)
                    continuation.resume(returning: (characters, filterValues))
                }
                .store(in: &subscribers)
        }
    }
    
    private func getFilterValues(fromCharacters characters: [Character]) -> Filter {
        
        var professions = Set<String>()
        var hairColors = Set<String>()
        var names = Set<String>()
        
        characters.forEach ({
            $0.professions.forEach { professions.insert($0) }
            hairColors.insert($0.hairColor)
            names.insert($0.name)
        })
        
        let minAge = characters.min { $0.age < $1.age }?.age ?? 0
        let maxAge = characters.max { $0.age < $1.age }?.age ?? 0
        let minWeight = Int(characters.min { $0.weight < $1.weight }?.weight ?? 0)
        let maxWeight = Int(characters.max { $0.weight < $1.weight }?.weight ?? 0)
        let minHeight = Int(characters.min { $0.height < $1.height }?.height ?? 0)
        let maxHeight = Int(characters.max { $0.height < $1.height }?.height ?? 0)
        let minFriends = Int(characters.min { $0.friends.count < $1.friends.count }?.friends.count ?? 0)
        let maxFriends = Int(characters.max { $0.friends.count < $1.friends.count }?.friends.count ?? 0)
    
        return Filter(age: minAge...maxAge,
                      weight: minWeight...maxWeight,
                      height: minHeight...maxHeight,
                      hairColor: Array(hairColors),
                      profession: Array(professions),
                      friends: minFriends...maxFriends)
    }
}
