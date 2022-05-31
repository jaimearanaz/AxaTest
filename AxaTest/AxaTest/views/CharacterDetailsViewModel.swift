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
    
    func didSelectFriend(id: Int)
}

protocol CharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModelOutput, CharacterDetailsViewModelInput {
    
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase { get set }
    var getCharacterByIdUseCase: GetCharacterByIdUseCase { get set }
    var getCharactersByNameUseCase: GetCharactersByNameUseCase { get set }
}

class DefaultCharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModel {

    var character = Box(CharacterDetailsUi())
    var transitionTo = Box(CharacterDetailsTransitions.none)
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase
    var getCharacterByIdUseCase: GetCharacterByIdUseCase
    var getCharactersByNameUseCase: GetCharactersByNameUseCase
    
    init(getSelectedCharacterUseCase: GetSelectedCharacterUseCase,
         getCharacterByIdUseCase: GetCharacterByIdUseCase,
         getCharactersByNameUseCase: GetCharactersByNameUseCase) {
        
        self.getSelectedCharacterUseCase = getSelectedCharacterUseCase
        self.getCharacterByIdUseCase = getCharacterByIdUseCase
        self.getCharactersByNameUseCase = getCharactersByNameUseCase
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getSelectedCharacterUseCase.execute { result in
            
            switch result {
            case .success(let character):
                
                self.getCharacterDetailsUi(fromCharacter: character) { result in
                    switch result {
                    case .success(let character):
                        self.character.value = character
                    case .failure(let error):
                        self.showErrorAndDismiss(error: error)
                    }
                }
                
            case .failure(let error):
                self.showErrorAndDismiss(error: error)
            }
        }
    }
    
    func didSelectFriend(id: Int) {
        
        getCharacterByIdUseCase.execute(id: id) { result in
            
            switch result {
            case .success(let character):
                
                self.getCharacterDetailsUi(fromCharacter: character) { result in
                    switch result {
                    case .success(let character):
                        self.character.value = character
                    case .failure(let error):
                        self.showErrorAndDismiss(error: error)
                    }
                }
                
            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
    }
    
    private func getCharacterDetailsUi(fromCharacter character: Character,
                                       completion: @escaping (Result<CharacterDetailsUi, Error>) -> Void) {
        
        getCharactersByNameUseCase.execute(names: character.friends) { result in
            
            switch result {
                
            case .success(let friends):
                let friends = friends.map { $0.toFriendUi() }
                var characterUi = character.toCharacterDetailsUi()
                characterUi.friends = friends
                completion(.success(characterUi))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func showErrorAndDismiss(error: Error) {
        
        errorMessage.value = error.localizedDescription
        transitionTo.value = .dismiss
    }
}
