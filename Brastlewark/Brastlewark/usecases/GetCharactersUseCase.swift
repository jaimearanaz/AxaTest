//
//  GetCharactersUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import Combine

protocol GetCharactersUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }

    func execute() async throws -> [Character]
}

class DefaultGetCharactersUseCase: GetCharactersUseCase {

    var cachedRepository: CachedRepositoryProtocol
    private var subscribers = Set<AnyCancellable>()
    
    init(repository: CachedRepositoryProtocol) {
        self.cachedRepository = repository
    }
    
    func execute() async throws -> [Character] {
        do {
            return try await cachedRepository.getCharacters()
        } catch let error {
            throw error
        }
    }
}
