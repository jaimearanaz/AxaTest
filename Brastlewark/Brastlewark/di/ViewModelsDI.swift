//
//  ViewModelsDI.swift
//  Brastlewark
//
//  Created by Jaime Aranaz on 13/6/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func registerViewModels() {
        
        defaultContainer.register(CharacterDetailsViewModel.self) { resolver in
            DefaultCharacterDetailsViewModel(getSelectedCharacterUseCase: resolver.resolve(GetSelectedCharacterUseCase.self)!,
                                             saveSelectCharacterUseCase: resolver.resolve(SaveSelectedCharacterUseCase.self)!,
                                             getCharactersByNameUseCase: resolver.resolve(GetCharactersByNameUseCase.self)!)
        }
        defaultContainer.register(FilterViewModel.self) { resolver in
            DefaultFilterViewModel(getFilterValuesUseCase: resolver.resolve(GetFilterValuesUseCase.self)!,
                                   getFilterActiveUseCase: resolver.resolve(GetFilterActiveUseCase.self)!,
                                   saveFilterActiveUserCase: resolver.resolve(SaveFilterActiveUseCase.self)!)
        }
        defaultContainer.register(GridViewModel.self) { resolver in
            DefaultGridViewModel(getCharactersUseCase: resolver.resolve(GetCharactersUseCase.self)!,
                                 getFilterActiveUseCase: resolver.resolve(GetFilterActiveUseCase.self)!,
                                 getFilterValuesUseCase: resolver.resolve(GetFilterValuesUseCase.self)!,
                                 getFilteredCharactersUseCase: resolver.resolve(GetFilteredCharactersUseCase.self)!,
                                 resetFilterActiveUserCase: resolver.resolve(ResetFilterActiveUseCase.self)!,
                                 saveSelectedCharacter: resolver.resolve(SaveSelectedCharacterUseCase.self)!,
                                 getSearchedCharactersUseCase: resolver.resolve(GetSearchedCharactersUseCase.self)!,
                                 invalidateCachedData: resolver.resolve(InvalidateCachedDataUseCase.self)!)
        }
    }
}
