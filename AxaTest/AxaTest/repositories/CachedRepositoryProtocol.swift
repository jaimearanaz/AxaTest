//
//  CachedRepositoryProtocol.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation

protocol CachedRepositoryProtocol {
    
    func getCharacters() async throws -> [Character]
    func getFilterValues() async throws -> Filter
}
