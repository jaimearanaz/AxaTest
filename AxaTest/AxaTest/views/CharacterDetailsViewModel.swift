//
//  CharacterDetailsViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 29/5/22.
//

import Foundation

enum CharacterDetailsTransitions: String {
    
    case none
    case dismiss
}

protocol CharacterDetailsViewModelOutput: BaseViewModelOutput {
    
    var character: Box<CharacterDetailsUi> { get set }
    var transitionTo: Box<CharacterDetailsTransitions> { get set }
}

protocol CharacterDetailsViewModelInput: BaseViewModelInput {
    
    func didSelectFriend(_ id: Int)
}

protocol CharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModelOutput, CharacterDetailsViewModelInput {
    
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase { get set }
    var getCharacterByIdUseCase: GetCharacterByIdUseCase { get set }
}

class DefaultCharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModel {

    var character = Box(CharacterDetailsUi())
    var transitionTo = Box(CharacterDetailsTransitions.none)
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase
    var getCharacterByIdUseCase: GetCharacterByIdUseCase
    
    init(getSelectedCharacterUseCase: GetSelectedCharacterUseCase, getCharacterByIdUseCase: GetCharacterByIdUseCase) {
        
        self.getSelectedCharacterUseCase = getSelectedCharacterUseCase
        self.getCharacterByIdUseCase = getCharacterByIdUseCase
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getSelectedCharacterUseCase.execute { result in
            
            switch result {
            case .success(let character):
                self.character.value = character.toCharacterDetailsUi()
            case .failure(let error):
                self.showErrorAndDismiss(error: error)
            }
        }
    }
    
    func didSelectFriend(_ id: Int) {
     
        getCharacterByIdUseCase.execute(id: id) { result in
            
            switch result {
            case .success(let character):
                self.character.value = character.toCharacterDetailsUi()
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func showErrorAndDismiss(error: Error) {
        
        errorMessage.value = error.localizedDescription
        transitionTo.value = .dismiss
    }
}
