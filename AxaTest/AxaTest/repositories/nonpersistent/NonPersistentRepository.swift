//
//  NonPersistentRepository.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

class NonPersistentRepository: NonPersistentRepositoryProtocol {
    
    var characters: [Character]?
    var selectedCharacter: Int?
    var filterValues: Filter?
    var filterActive: Filter?

    func saveCharacters(_ characters: [Character]) {
        self.characters = characters
    }
    
    func getSavedCharacters() -> [Character]? {
        return characters
    }
    
    func saveFilterActive(_ filter: Filter) {
        filterActive = filter
    }
    
    func getFilterActive() -> Filter? {
        return filterActive
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
    
    func invalidateData() {
        
        characters = nil
        selectedCharacter = nil
        filterValues = nil
        filterActive = nil
    }
}
