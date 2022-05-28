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
}

class DefaultGridViewModel: BaseViewModel, GridViewModel {
    
    var isLoading = Box(false)
    var errorMessage = Box("")
    var characters = Box([CharacterGrid]())
    var transitionTo = Box(GridTransitions.none)
    var getCharactersUseCase: GetCharactersUseCase
    var getActiveFilterUseCase: GetActiveFilterUseCase
    var getFilteredCharactersUseCase: GetFilteredCharactersUseCase
    
    init(getCharactersUseCase: GetCharactersUseCase,
         getActiveFilterUseCase: GetActiveFilterUseCase,
         getFilteredCharactersUseCase: GetFilteredCharactersUseCase) {
        
        self.getCharactersUseCase = getCharactersUseCase
        self.getActiveFilterUseCase = getActiveFilterUseCase
        self.getFilteredCharactersUseCase = getFilteredCharactersUseCase
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        
        isLoading.value = true
        getCharactersUseCase.execute { result in
            
            self.isLoading.value = false
            switch result {
            case .success(let characters):
                self.characters.value = characters.map { $0.toCharacterGrid() }
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
                break
            }
        }
    }
    
    override func viewDidAppear() {
        print("viewDidAppear")
        
        if !isLoading.value {
            
            isLoading.value = true
            getFilteredCharactersUseCase.execute { result in
                
                self.isLoading.value = false
                switch result {
                case .success(let characters):
                    self.characters.value = characters.map { $0.toCharacterGrid() }
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                    break
                }
            }
        }
    }
    
    func didSelectFilter() {
        print("didSelectFilter")
        transitionTo.value = .toFilter
    }
    
    func didSelectReset() {
        print("didSelectReset")
    }
    
    func didSelectCharacter(id: Int) {
        print("didSelectCharacter id \(id)")
    }
}
