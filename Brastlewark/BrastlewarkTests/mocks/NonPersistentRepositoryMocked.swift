//
//  NonPersistentRepositoryMocked.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

@testable import Brastlewark

class NonPersistentMocked: NonPersistentRepositoryProtocol {
    
    var charactersToReturn: [Character]?
    var filterActiveToReturn: Filter?
    var getSavedCharactersCalled = false
    
    private var filterValues: Filter?
    
    func saveCharacters(_ characters: [Character]) {
        
    }
    
    func getSavedCharacters() -> [Character]? {
        
        getSavedCharactersCalled = true
        return charactersToReturn
    }
    
    func saveFilterActive(_ filter: Filter) {
        
    }
    
    func getFilterActive() -> Filter? {
        return filterActiveToReturn
    }
    
    func saveFilterValues(_ filter: Filter) {
        filterValues = filter
    }
    
    func getFilterValues() -> Filter? {
        return filterValues
    }
    
    func saveSelectedCharacter(id: Int) {
        
    }
    
    func getSelectedCharacter() -> Int? {
        return 0
    }
    
    func invalidateData() {
        
    }
}
