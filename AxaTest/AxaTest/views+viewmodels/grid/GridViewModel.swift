//
//  GridViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation

enum GridTransitions: String {
    
    case toFilter
    case toCharacter
}

protocol GridViewModelOutput: BaseViewModelOutput {
    
    var characters: Box<[CharacterGridUi]> { get set }
    var isFilterActive: Box<Bool> { get set }
    var transitionTo: Box<GridTransitions?> { get set }
}

protocol GridViewModelInput: BaseViewModelInput {
    
    func didSelectFilter()
    func didSelectReset()
    func didSelectCharacter(id: Int)
    func didRefresh()
}

protocol GridViewModel: BaseViewModel, GridViewModelOutput, GridViewModelInput {
 
    var getCharactersUseCase: GetCharactersUseCase { get set }
    var getFilterActiveUseCase: GetFilterActiveUseCase { get set }
    var getFilterValuesUseCase: GetFilterValuesUseCase { get set }
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase { get set }
    var resetFilterActiveUserCase: ResetFilterActiveUseCase { get set }
    var saveSelectedCharacter: SaveSelectedCharacterUseCase { get set }
    var invalidateCachedData: InvalidateCachedDataUseCase { get set }
}

class DefaultGridViewModel: BaseViewModel, GridViewModel {
    
    var characters = Box([CharacterGridUi]())
    var isFilterActive = Box(false)
    var transitionTo = Box<GridTransitions?>(nil)
    var getCharactersUseCase: GetCharactersUseCase
    var getFilterActiveUseCase: GetFilterActiveUseCase
    var getFilterValuesUseCase: GetFilterValuesUseCase
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase
    var resetFilterActiveUserCase: ResetFilterActiveUseCase
    var saveSelectedCharacter: SaveSelectedCharacterUseCase
    var invalidateCachedData: InvalidateCachedDataUseCase
    
    init(getCharactersUseCase: GetCharactersUseCase,
         getFilterActiveUseCase: GetFilterActiveUseCase,
         getFilterValuesUseCase: GetFilterValuesUseCase,
         getFilteredCharactersUseCase: GetFilteredCharactersUseCase,
         resetFilterActiveUserCase: ResetFilterActiveUseCase,
         saveSelectedCharacter: SaveSelectedCharacterUseCase,
         invalidateCachedData: InvalidateCachedDataUseCase) {
        
        self.getCharactersUseCase = getCharactersUseCase
        self.getFilterActiveUseCase = getFilterActiveUseCase
        self.getFilterValuesUseCase = getFilterValuesUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
        self.resetFilterActiveUserCase = resetFilterActiveUserCase
        self.saveSelectedCharacter = saveSelectedCharacter
        self.invalidateCachedData = invalidateCachedData
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Task.init {
            do {
                isLoading.value = true
                let characters = try await getCharactersUseCase.execute()
                isLoading.value = false
                self.characters.value = characters.map { $0.toCharacterGridUi() }
                isFilterActive.value = false
            } catch let error {
                isLoading.value = false
                errorMessage.value = error.localizedDescription
            }
        }
    }
    
    override func viewDidAppear() {

        super.viewDidAppear()
        if !isLoading.value {
            updateCharacters()
            updateResetButton()
        }
    }
        
    func didSelectFilter() {
        transitionTo.value = .toFilter
    }
    
    func didSelectReset() {
        
        Task.init {
            do {
                isLoading.value = true
                try await resetFilterActiveUserCase.execute()
                isLoading.value = false
                updateCharacters()
                isFilterActive.value = false
            } catch let error {
                isLoading.value = false
                errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func didSelectCharacter(id: Int) {
        
        Task.init {
            await saveSelectedCharacter.execute(id:id)
            transitionTo.value = .toCharacter
        }
    }
    
    func didRefresh() {
        
        Task.init {
            await invalidateCachedData.execute()
            updateCharacters()
            isFilterActive.value = false
        }
    }
    
    private func updateCharacters() {
        
        Task.init {
            do {
                isLoading.value = true
                let characters = try await getFilteredCharactersUseCase.execute()
                isLoading.value = false
                self.characters.value = characters.map { $0.toCharacterGridUi() }
            } catch let error {
                isLoading.value = false
                errorMessage.value = error.localizedDescription
            }
        }
    }
    
    
    private func updateResetButton() {
        
        Task.init {
            do {
                let filterValues = try await getFilterValuesUseCase.execute()
                let filterActive = try await getFilterActiveUseCase.execute()
                isFilterActive.value = !(filterValues == filterActive)
            } catch let error {
                isLoading.value = false
                errorMessage.value = error.localizedDescription
            }
        }
    }
}
