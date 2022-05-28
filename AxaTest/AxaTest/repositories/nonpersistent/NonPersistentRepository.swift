//
//  NonPersistentRepository.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

class NonPersistentRepository: NonPersistentRepositoryProtocol {
    
    var characters = [Character]()
    var selectedCharacter: Int?
    var filterValues: Filter?
    var activeFilter: Filter?

    func saveCharacters(_ characters: [Character]) {
        self.characters = characters
    }
    
    func getSavedCharacters() -> [Character] {
        return characters
    }
    
    func saveActiveFilter(_ filter: Filter) {
        activeFilter = filter
    }
    
    func getActiveFilter() -> Filter? {
        return activeFilter
    }
    
    func saveFilterValues(_ filter: Filter) {
        filterValues = filter
    }
    
    func getFilterValues() -> Filter? {
        return filterValues
    }
    
    func saveSelectedCharacter( id: Int) {
        selectedCharacter = id
    }
    
    func getSelectedCharacter() -> Int? {
        return selectedCharacter
    }
}
