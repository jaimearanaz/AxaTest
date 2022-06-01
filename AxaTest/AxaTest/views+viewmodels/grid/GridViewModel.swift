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
    var transitionTo: Box<GridTransitions?> { get set }
}

protocol GridViewModelInput: BaseViewModelInput {
    
    func didSelectFilter()
    func didSelectReset()
    func didSelectCharacter(id: Int)
}

protocol GridViewModel: BaseViewModel, GridViewModelOutput, GridViewModelInput {
 
    var getCharactersUseCase: GetCharactersUseCase { get set }
    var getFilterActiveUseCase: GetFilterActiveUseCase { get set }
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase { get set }
    var resetFilterActiveUserCase: ResetFilterActiveUseCase { get set }
    var saveSelectedCharacter: SaveSelectedCharacterUseCase { get set }
}

class DefaultGridViewModel: BaseViewModel, GridViewModel {
    
    var characters = Box([CharacterGridUi]())
    var transitionTo = Box<GridTransitions?>(nil)
    var getCharactersUseCase: GetCharactersUseCase
    var getFilterActiveUseCase: GetFilterActiveUseCase
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase
    var resetFilterActiveUserCase: ResetFilterActiveUseCase
    var saveSelectedCharacter: SaveSelectedCharacterUseCase
    
    init(getCharactersUseCase: GetCharactersUseCase,
         getFilterActiveUseCase: GetFilterActiveUseCase,
         getFilteredCharactersUseCase: GetFilteredCharactersUseCase,
         resetFilterActiveUserCase: ResetFilterActiveUseCase,
         saveSelectedCharacter: SaveSelectedCharacterUseCase) {
        
        self.getCharactersUseCase = getCharactersUseCase
        self.getFilterActiveUseCase = getFilterActiveUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
        self.resetFilterActiveUserCase = resetFilterActiveUserCase
        self.saveSelectedCharacter = saveSelectedCharacter
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Task.init {
            do {
                isLoading.value = true
                let characters = try await getCharactersUseCase.execute()
                isLoading.value = false
                self.characters.value = characters.map { $0.toCharacterGridUi() }
            } catch let error {
                isLoading.value = false
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    override func viewDidAppear() {

        super.viewDidAppear()
        if !isLoading.value {
            updateCharacters()
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
            } catch let error {
                isLoading.value = false
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func didSelectCharacter(id: Int) {
        
        Task.init {
            await saveSelectedCharacter.execute(id:id)
            transitionTo.value = .toCharacter
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
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
}
