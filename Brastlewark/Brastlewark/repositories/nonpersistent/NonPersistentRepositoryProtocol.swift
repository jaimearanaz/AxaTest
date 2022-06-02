//
//  NonPersistentRepositoryProtocol.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

protocol NonPersistentRepositoryProtocol {
    
    func saveCharacters(_ characters: [Character])
    func getSavedCharacters() -> [Character]?
    func saveFilterActive(_ filter: Filter)
    func getFilterActive() -> Filter?
    func saveFilterValues(_ filter: Filter)
    func getFilterValues() -> Filter?
    func saveSelectedCharacter(id: Int)
    func getSelectedCharacter() -> Int?
    func invalidateData()
}
