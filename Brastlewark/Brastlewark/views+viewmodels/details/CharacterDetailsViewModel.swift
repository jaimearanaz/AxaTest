//
//  CharacterDetailsViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 29/5/22.
//

import Foundation

enum CharacterDetailsTransitions: String {
    
    case toFriend
    case toGrid
}

protocol CharacterDetailsViewModelOutput: BaseViewModelOutput {
    
    var character: Box<CharacterDetailsUi> { get set }
    var transitionTo: Box<CharacterDetailsTransitions?> { get set }
}

protocol CharacterDetailsViewModelInput: BaseViewModelInput {
    
    func didSelectBack()
    func didSelectFriend(id: Int)
}

protocol CharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModelOutput, CharacterDetailsViewModelInput {
    
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase { get set }
    var saveSelectCharacterUseCase: SaveSelectedCharacterUseCase { get set }
    var getCharactersByNameUseCase: GetCharactersByNameUseCase { get set }
}

class DefaultCharacterDetailsViewModel: BaseViewModel, CharacterDetailsViewModel {

    var character = Box(CharacterDetailsUi())
    var transitionTo = Box<CharacterDetailsTransitions?>(nil)
    var getSelectedCharacterUseCase: GetSelectedCharacterUseCase
    var saveSelectCharacterUseCase: SaveSelectedCharacterUseCase
    var getCharactersByNameUseCase: GetCharactersByNameUseCase
    
    init(getSelectedCharacterUseCase: GetSelectedCharacterUseCase,
         saveSelectCharacterUseCase: SaveSelectedCharacterUseCase,
         getCharactersByNameUseCase: GetCharactersByNameUseCase) {
        
        self.getSelectedCharacterUseCase = getSelectedCharacterUseCase
        self.saveSelectCharacterUseCase = saveSelectCharacterUseCase
        self.getCharactersByNameUseCase = getCharactersByNameUseCase
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Task.init {
            do {
                let character = try await getSelectedCharacterUseCase.execute()
                let characterUi = try await getCharacterDetailsUi(fromCharacter: character)
                self.character.value = characterUi
            } catch let error {
                showErrorAndDismiss(error: error)
           }
        }
    }
    
    func didSelectBack() {
        transitionTo.value = .toGrid
    }
    
    func didSelectFriend(id: Int) {
        
        Task.init {
            await saveSelectCharacterUseCase.execute(id:id)
            transitionTo.value = .toFriend
        }
    }
    
    private func getCharacterDetailsUi(fromCharacter character: Character) async throws -> CharacterDetailsUi {
        
        do {
            let friends = try await getCharactersByNameUseCase.execute(names: character.friends)
            let friendsUi = friends.map { $0.toFriendUi() }
            var characterUi = character.toCharacterDetailsUi()
            characterUi.friends = friendsUi
            return characterUi
        } catch let error {
            throw error
        }
    }
    
    private func showErrorAndDismiss(error: Error) {
        
        errorMessage.value = error.localizedDescription
        transitionTo.value = .toGrid
    }
}
