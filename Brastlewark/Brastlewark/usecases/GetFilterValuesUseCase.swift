//
//  GetFilterValuesUseCase.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol GetFilterValuesUseCase {
    
    var cachedRepository: CachedRepositoryProtocol { get set }
    
    func execute() async throws -> Filter
}

class DefaultGetFilterValuesUseCase: GetFilterValuesUseCase {

    var cachedRepository: CachedRepositoryProtocol
    
    init(cachedRepository: CachedRepositoryProtocol) {
        self.cachedRepository = cachedRepository
    }
    
    func execute() async throws -> Filter {
        do {
            return try await cachedRepository.getFilterValues()
        } catch let error {
            throw error
        }
    }
}
