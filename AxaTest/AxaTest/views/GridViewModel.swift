//
//  GridViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation

enum GridTransitions: String {
    
    case none
    case toFilter
    case toCharacter
}

protocol GridViewModelOutput: BaseViewModelOutput {
    
    var isLoading: Box<Bool> { get set }
    var errorMessage: Box<String> { get set }
    var characters: Box<[CharacterGrid]> { get set }
    var transitionTo: Box<GridTransitions> { get set }
}

protocol GridViewModelInput: BaseViewModelInput {
    
    func didSelectFilter()
    func didSelectReset()
    func didSelectCharacter(id: Int)
}

protocol GridViewModel: BaseViewModel, GridViewModelOutput, GridViewModelInput {
 
    var getCharactersUseCase: GetCharactersUseCase { get set }
    var getActiveFilterUseCase: GetActiveFilterUseCase { get set }
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase { get set }
    var resetActiveFilterUserCase: ResetActiveFilterUseCase { get set }
    var saveSelectedCharacter: SaveSelectedCharacterUseCase { get set }
}

class DefaultGridViewModel: BaseViewModel, GridViewModel {
    
    var isLoading = Box(false)
    var errorMessage = Box("")
    var characters = Box([CharacterGrid]())
    var transitionTo = Box(GridTransitions.none)
    var getCharactersUseCase: GetCharactersUseCase
    var getActiveFilterUseCase: GetActiveFilterUseCase
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase
    var resetActiveFilterUserCase: ResetActiveFilterUseCase
    var saveSelectedCharacter: SaveSelectedCharacterUseCase
    
    init(getCharactersUseCase: GetCharactersUseCase,
         getActiveFilterUseCase: GetActiveFilterUseCase,
         getFilteredCharactersUseCase: GetFilteredCharactersUseCase,
         resetActiveFilterUserCase: ResetActiveFilterUseCase,
         saveSelectedCharacter: SaveSelectedCharacterUseCase) {
        
        self.getCharactersUseCase = getCharactersUseCase
        self.getActiveFilterUseCase = getActiveFilterUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
        self.resetActiveFilterUserCase = resetActiveFilterUserCase
        self.saveSelectedCharacter = saveSelectedCharacter
    }
    
    override func viewDidLoad() {

        isLoading.value = true
        getCharactersUseCase.execute { result in
            
            self.isLoading.value = false
            switch result {
            case .success(let characters):
                self.characters.value = characters.map { $0.toCharacterGrid() }
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    override func viewDidAppear() {

        if !isLoading.value {
            updateCharacters()
        }
    }
        
    func didSelectFilter() {
        transitionTo.value = .toFilter
    }
    
    func didSelectReset() {
        
        resetActiveFilterUserCase.execute { result in
            
            switch result {
            case .success():
                self.updateCharacters()
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    func didSelectCharacter(id: Int) {
        
        saveSelectedCharacter.execute(id: id) { result in
            
            switch result {
            case .success():
                self.transitionTo.value = .toCharacter
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func updateCharacters() {
        
        getFilteredCharactersUseCase.execute { result in
            
            switch result {
            case .success(let characters):
                self.characters.value = characters.map { $0.toCharacterGrid() }
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
}
