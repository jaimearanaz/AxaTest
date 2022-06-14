//
//  UseCasesDI.swift
//  Brastlewark
//
//  Created by Jaime Aranaz on 13/6/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {

    @objc class func registerUseCases() {

        defaultContainer.register(GetCharactersUseCase.self) { resolver in
            DefaultGetCharactersUseCase(repository: resolver.resolve(CachedRepositoryProtocol.self)!)
        }
        defaultContainer.register(GetCharactersByNameUseCase.self) { resolver in
            DefaultGetCharactersByNameUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!,
                                              nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(GetFilterActiveUseCase.self) { resolver in
            DefaultGetFilterActiveUseCase(nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(GetFilteredCharactersUseCase.self) { resolver in
            DefaultGetFilteredCharactersUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!,
                                                nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(GetFilterValuesUseCase.self) { resolver in
            DefaultGetFilterValuesUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!)
        }
        defaultContainer.register(GetSearchedCharactersUseCase.self) { resolver in
            DefaultGetSearchedCharactersUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!,
                                                nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!,
                                                getFilteredCharactersUseCase: resolver.resolve(GetFilteredCharactersUseCase.self)!)
        }
        defaultContainer.register(GetSelectedCharacterUseCase.self) { resolver in
            DefaultGetSelectedCharacterUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!,
                                               nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(InvalidateCachedDataUseCase.self) { resolver in
            DefaultInvalidateCachedDataUseCase(nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
            
        }
        defaultContainer.register(ResetFilterActiveUseCase.self) { resolver in
            DefaultResetFilterActiveUseCase(cachedRepository: resolver.resolve(CachedRepositoryProtocol.self)!,
                                            nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(SaveFilterActiveUseCase.self) { resolver in
            DefaultSaveFilterActiveUseCase(nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
        defaultContainer.register(SaveSelectedCharacterUseCase.self) { resolver in
            DefaultSaveSelectedCharacterUseCase(nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self)!)
        }
    }
}
